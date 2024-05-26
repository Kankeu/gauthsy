import Vue from 'vue'
import Vuetify from 'vuetify'
import VueRouter from 'vue-router'
import 'vuetify/dist/vuetify.min.css'
import VueTimeAgo from 'vue-timeago'
import VueApollo from 'vue-apollo'
import {ApolloClient} from 'apollo-client'
import {createUploadLink} from 'apollo-upload-client'
import {setContext} from "apollo-link-context"
import {onError} from 'apollo-link-error'
import {InMemoryCache, defaultDataIdFromObject} from 'apollo-cache-inmemory'

import VueCodeHighlight from "vue-code-highlight";


import authRepository from '@repositories/AuthRepository'

import App from '@/App'
import Config from '@config/Config'
import Global from '@mixins/Global'
import Home from '@views/home/Home'
import Scanner from '@views/scanner/Scanner'
import ScannerBoarding from '@views/scanner/ScannerBoarding'
import DocumentSubmitted from '@views/scanner/DocumentSubmitted'
import Dashboard from "@views/dashboard/Dashboard";
import Splash from '@views/splash/Splash'
import Profile from "@views/profile/Profile";
import Starting from '@views/starting/Starting'
import NotFound from "./components/graphql/NotFound";
import MApolloQuery from "@components/graphql/MApolloQuery";
import MApolloMutation from "@components/graphql/MApolloMutation";


Vue.use(Vuetify);
Vue.mixin(Global);
Vue.use(VueRouter);
Vue.use(VueApollo);

Vue.use(VueTimeAgo, {
    name: 'timeAgo',
    locale: 'en',
    locales: {
        'en': require('date-fns/locale/en'),
    }
})

Vue.component('MApolloMutation', MApolloMutation)
Vue.component('MApolloQuery', MApolloQuery)
Vue.use(VueCodeHighlight);

const vuetify = new Vuetify(
    {
        icons: {
            iconfont: "md"
        },
        theme: {
            themes: {
                light: {
                    primary: "#1c3144", // #E53935
                    secondary: {
                        base: "#808080", // #808080
                        lighten5: "#fff" // #f4f6f9
                    },
                    accent: "#0096c7", //"#1574f5", // #3F51B5
                    anchor: "#f4f6f9" // #f4f6f9
                },
            }
        },
    }
)

const router = new VueRouter({
    mode: 'history',
    routes: [
        {path: '/', component: Starting, name: 'starting'},
        {path: '/home', component: Home, name: 'home', meta: {guarded: true}},
        {path: '/splash', component: Splash, name: 'splash'},
        {
            path: '/dashboard', component: Dashboard, name: 'dashboard', meta: {guarded: true},
        },
        {
            path: '/profile', component: Profile, name: 'profile', meta: {guarded: true},
        },
        {
            path: '/scanner', component: Scanner, name: 'scanner', //meta: {guarded: true},
        },
        {
            path: '/boarding', component: ScannerBoarding, name: 'boarding', //meta: {guarded: true},
        },
        {
            path: '/submitted', component: DocumentSubmitted, name: 'submitted', //meta: {guarded: true},
        },

        {
            path: '*', component: NotFound, name: 'not_found'
        }
    ],
    scrollBehavior(to, from, savedPosition) {
        if (to.hash) {
            return {selector: to.hash, offset: {y: 120}}
        }
    },

})

router.beforeEach((to, from, next) => {
    if (to.meta.guarded)
        return authRepository.guard(to, from, next)
    else return next(true)
})

authRepository.run(router)

const httpLink = createUploadLink({
    uri: Config.apiUrl
})

const httpLinkAuth = setContext((_, {headers}) => {
    const auth = authRepository.auth;
    return {
        headers: {
            ...headers,
            Accept: 'application/json',
            Authorization: auth ? `${auth.token_type} ${auth.access_token}` : ""
        }
    };
})

const cache = new InMemoryCache({
        dataIdFromObject: (object) => {
            if (object instanceof Object && object['id'] != null)
                return object['id'];
            return defaultDataIdFromObject(object);
        }
    }
)

const apolloClient = new ApolloClient({
    link: onError(({networkError, graphQLErrors}) => {
        console.log({graphQLErrors, networkError})
        if (graphQLErrors && graphQLErrors.find(e => ['authentication'].includes(e.extensions.category)) != null) {
            authRepository.logout()
        }
    }).concat(httpLinkAuth.concat(httpLink)),
    cache,
})

const apolloProvider = new VueApollo({
    defaultClient: apolloClient,
})

new Vue({
    router,
    vuetify,
    apolloProvider,
    render: h => h(App),
}).$mount('#vue-app')
