export default {
    get _env() {
        return process.env.NODE_ENV === 'development' ? 'dev' : 'prod'
    },

    get isDev() {
        return this._env === "dev"
    },

    get isTest() {
        return this._env === "test"
    },

    get isProd() {
        return this._env === "prod"
    },

    get appName() {
        return "GAuthSy"
    },

    domainName: "https://gauthsy.restopres.com",

    get appUrl() {//http://95.88.230.98:8000
        return this.isProd ? this.domainName : "http://localhost:8000"
    },

    get apiUrl() {
        return this.isProd ? this.appUrl + "/graphql" : "/graphql"
    },

    ipApi: "https://ipapi.co/json",

    get images() {
        let that = this
        return {
            get logo() {
                return  "/images/defaults/logo.png"
            },
            get startingBg() {
                return '/images/defaults/bg.svg';
            }
        }
    }
}
