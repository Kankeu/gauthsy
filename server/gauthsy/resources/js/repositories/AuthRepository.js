import eventManager from "@kernel/EventManager"
import Config from "@config/Config";

const parseUrl = require('url-parse');

class AuthRepository {

    get auth() {
        return localStorage.auth ? JSON.parse(localStorage.auth) : null
    }

    get user() {
        return opt(this.auth).me
    }

    set user(v) {
        assert(v instanceof Object)
        let tmp = this.auth
        tmp.me = {...opt(opt(this.auth).me), ...v}
        localStorage.setItem('auth', JSON.stringify(tmp))
    }

    login(auth) {
        assert(auth != null && auth.access_token != null && auth.me.id != null)
        localStorage.setItem('auth', JSON.stringify({...auth, created_at: Date.now()}))
        eventManager.trigger("logged_in", this.auth)
    }

    logout() {
        localStorage.removeItem('auth')
        if (this.vm.$route.name !== 'starting')
            this.vm.$router.push({
                name: 'starting',
            })
        eventManager.trigger("logged_out")
    }

    get logged() {
        // check if the user exists and the accessToken is not expired
        return this.auth != null && ((this.auth.created_at + this.auth.expires_in * 1000) - Date.now()) > 30
    }

    guard(to, from, next) {
        let that = require("@repositories/AuthRepository").default
        if (that.logged) return next(from.name !== 'dashboard' || opt(this.user).is_admin === true)
        that.vm.pushQuery({sign_in: "1"})
        if (window.watcher) window.watcher()
        let id = eventManager.attach("logged_in", _ => that.vm.$router.push(to))

        let unwatch = that.vm.$watch("$route.query.sign_in", v => {
            if (v !== "1") {
                if (from.name === 'splash')
                    next({name: 'starting', replace: true})
                eventManager.detach("logged_in", id)
            }
        })
        window.watcher = () => {
            eventManager.detach("logged_in", id);
            unwatch()
        }

        return next(false)
    }

    async init(vm) {
        this.vm = vm
        try {
            await this.vm.tapAsync(async _ => {
                try {
                    let res = await this.vm.$apollo.query({
                        query: require("@graphql/auth").ME,
                        fetchPolicy: "network-only",
                    })
                    if (res.data.me == null)
                        localStorage.removeItem('auth')
                    else {
                        this.user = res.data.me
                    }
                } catch (e) {
                    if (e.graphQLErrors == null || e.graphQLErrors.length === 0 || e.graphQLErrors[0].extensions.category !== "authentication")
                        throw e;
                }
            }, 3)
        } catch (e) {
            console.error(e)
        }
        let path = this.path
        let router = this.router
        if (path.includes('/splash'))
            path = "/"

        let api = path.includes('/api/') ? path.split('/api/')[1] : "";

        if (api.includes('verified')) {
            api = api.split("verified/")[1]
            router.push({name: 'starting', query: {email_verification: api.replace("/", ":")}})
        } else if (api.includes('documents')) {
            router.push({name: 'home'})
        } else if (api.includes('reset')) {
            api = api.split("reset/")[1]
            router.push({name: 'starting', query: {reset_password: api}})
        } else if (api.includes('provider/')) {
            let url = parseUrl(path, true)
            let parts = (url.query.retrieve||"").split("]").filter(e=>e.length>0).flatMap(e=>e.replace(",[","").replace("[","").split(","))

            if (window.opener != null &&parts.length===(new Set(parts)).size&&parts.every(part => {
                let smParts = part.split(":");
                if (smParts.length === 2)
                    return ["CM", "DE", "RW"].includes(smParts[0]) && ["AR", "ID"].includes(smParts[1])
                return false
            })){
                router.push({name: 'home', query: {retrieve: url.query.retrieve,redirect:url.query.redirect}})
            }else {
                if (window.opener == null)
                    this.vm.$snackbar.show({
                        text: "You should open this page with window object of javascript",
                        color: 'error',
                    })
                else this.vm.$snackbar.show({
                    text: "The url to access the API is invalid",
                    color: 'error',
                })
                router.push({name: 'starting'})
                window.setTimeout(_=>window.close()
                ,3000)
            }
            // http://localhost:8000/api/provider/?retrieve=DE:AR&redirect=https://stackoverflow.com

        } else router.push(path)
    }


    async run(router) {
        let url = parseUrl(window.location.pathname + window.location.search + window.location.hash, true);
        let query = {}

        if (url.pathname === "/api/provider/" && url.query.retrieve != null && url.query.redirect != null) {
            let parts = url.query.retrieve.split("]").filter(e=>e.length>0).flatMap(e=>e.replace(",[","").replace("[","").split(","))
            console.log(parts)
            if (parts.length===(new Set(parts)).size&&parts.every(part => {
                let smParts = part.split(":");
                if (smParts.length === 2)
                    return ["CM", "DE", "RW"].includes(smParts[0]) && ["AR", "ID"].includes(smParts[1])
                return false
            })) {
                query.retrieve = url.query.retrieve
                query.redirect = url.query.redirect
            }
        } else {
            delete url.query.retrieve
            delete url.query.redirect
        }

        this.path = url.toString().substr(window.location.origin.length)

        router.push({name: 'splash', query})
        this.router = router
    }

}

export default new AuthRepository()
