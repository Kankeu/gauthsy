import authRepository from '@repositories/AuthRepository';
import eventManager from '@kernel/EventManager';


import Config from '@config/Config';

const copy = require('copy-text-to-clipboard');

window.assert = (condition, message) => {
    if (!condition) {
        throw message || "Assertion failed";
    }
}

NodeList.prototype.map = Array.prototype.map
NodeList.prototype.find = Array.prototype.find

window.loaders = {
    googleLoading: false
}
window.opt = (v, defaultValue) => {
    return v ? v : (defaultValue || {})
}

window.truncNum = (value) => {
    return Number((value).toFixed(2))
}

window.toFullPrice = (value) => {
    if (value instanceof Object) return truncNum(value.price) + " " + value.currency
    return truncNum(value) + " " + authRepository.currency
}
window.sleep = (ms) => {
    return new Promise(resolve => setTimeout(resolve, ms))
}
window.tapAsync = async (fun, tries = 3) => {
    for (let i = 1; i <= tries; i++) {
        try {
            return await fun();
        } catch (e) {
            console.error(e)
        }
    }
}
const pathBySize = (value, width, height) => {
    let words = value.split('.');
    let extension = words[words.length - 1];
    words[words.length - 1] = `${width}x${height}`;
    words.push(extension);
    return Config.appUrl + words.join('.');
}

const fullPath = (value) => {
    return value.startsWith("http") ? value : Config.appUrl + value;
}


export default {
    filters: {
        fromIntToDate(value){
            if(value==null) return null
            value += ""
            if(value.length!==6) return null
            let century = ((new Date()).getFullYear()+"").substr(0,2)
            let date = century+value.substr(0,2)+"-"+value.substr(2,2)+"-"+value.substr(4,2)
            if(((new Date()).getFullYear()+"").substr(2,2)>=value.substr(0,2)) return date
            century = (century-1)+""
            return century+value.substr(0,2)+"-"+value.substr(2,2)+"-"+value.substr(4,2)
        },
        imageSm(value) {
            if (!value.resized) return fullPath(value.path)
            return pathBySize(value.path, 400, 200)
        },
        pathBySize(value, width, height) {
            return pathBySize(value, width, height)
        },
        fullName(value) {
            return value.forename + " " + value.surname
        },
        fullPath(value) {
            return fullPath(value)
        },
        truncNum: window.window.truncNum,
        toFullPrice: window.window.toFullPrice,
        capitalize: function (value) {
            if (!value) return ''
            value = value.toString()
            return value.charAt(0).toUpperCase() + value.slice(1)
        }
    },
    computed: {
        window: _ => window,
        $snackbar() {
            if (window.snackbar == null) window.snackbar = {
                show(d) {
                    if (this.func != null) this.func(d)
                },
                listen(func) {
                    this.func = func
                }
            }
            return window.snackbar

        },
        breakpointIndex() {
            if (this.$vuetify.breakpoint.xsOnly) return 0
            if (this.$vuetify.breakpoint.smOnly) return 1
            if (this.$vuetify.breakpoint.mdOnly) return 2
            if (this.$vuetify.breakpoint.lgAndUp) return 3
        },
        $managers() {
            return {
                em: eventManager
            }
        },
        $repositories() {
            return {
                auth: authRepository,
            }
        },
        $config() {
            return Config;
        },
        innerWidth() {
            return this.$vuetify.breakpoint.width
        },
        innerHeight() {
            return this.$vuetify.breakpoint.height
        },
        opt() {
            return window.opt
        },
        $validations() {
            return {
                gt: (min) => v => !v && v != 0 || Number(v) > Number(min) || 'This field must be greater than ' + min,
                gte: (min) => v => !v && v != 0 || Number(v) >= Number(min) || 'This field must be greater or equal to ' + min,
                lt: (max) => v => !v && v != 0 || Number(v) < Number(max) || 'This field must be less than ' + max,
                lte: (max) => v => !v && v != 0 || Number(v) <= Number(max) || 'This field must be less or equal to ' + max,
                required: v => !!v || v == 0 || 'This field is required',
                confirmed: (value) => v => v === value || 'The passwords should be equals',
                filled: v => v instanceof File || (v instanceof Object ? Object.keys(v).length > 0 : (v && (v + "").trim().length > 0)) || !isNaN(parseInt(v)) && v == 0 || 'This field must be filled',
                email: v => /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(v) || 'Invalid e-mail',
                integer: v => /^[0123456789]{1,}$/.test(v) || 'This field must only contain number(s)',
                minLength: (length) => v => v && (v.length >= length) || "This field must contain at least " + length + " characters",
                maxLength: (length) => v => !v || (v.length <= length) || "This field must contain at most " + length + " characters",
                minDate: (min) => v => !v || new Date(v) >= new Date(min) || "The date must be greater than " + min,
                minTime: (min) => v => !v || parseInt(v.replace(":", "")) >= parseInt(min.replace(":", "")) || "The time must be greater than " + min,
                maxSize: (max) => v => !v || v.size / 1024 <= Number(max) || "The file must be smaller than " + max + " KB",
                make(...keys) {
                    const call = (funName, v, hasParams) => {
                        const parts = funName.split('(')
                        let tmp = this[parts[0]]
                        if (parts.length > 1) tmp = tmp(parts[1].split(')')[0])
                        return hasParams !== true ? tmp : tmp(v)
                    }
                    return keys.filter(x => typeof x === 'string').reduce((acc, x, i) => {
                        if (acc.length === 0) acc.push(call(x))
                        else acc.push(v => acc[i - 1](v) !== true ? acc[i - 1](v) : call(x, v, true))
                        return acc
                    }, [])
                }
            }
        },
        loremImg() {
            let min = Math.ceil(0);
            let max = Math.floor(10);
            return "http://lorempixel.com/400/200/food/" + (Math.floor(Math.random() * (max - min + 1)) + min);
        }
    },
    methods: {
        toCSSSelector(selector) {
            return CSS.escape(selector)
        },
        pushQuery(toQuery) {
            this.$router.replace({...this.$route, query: {...this.$route.query, ...toQuery}}).catch(_ => {
            })
        },
        popQuery(...fromQuery) {
            let query = {...this.$route.query}
            fromQuery.forEach(e => delete query[e])
            this.$router.replace({query}).catch(_ => {
            })
        },
        equalsJson(json1, json2) {
            return Object.keys(json1).find(k => {
                if (json1[k] instanceof Object && json2[k] instanceof Object) return this.equalsJson(json1[k], json2[k])
                return json1[k] !== json2[k]
            }) == null
        },
        tapAsync: window.tapAsync,
        copy(text) {
            copy(text)
            this.$snackbar.show({
                color: 'success',
                text: 'Copied'
            })
        },
        cloneJson(json) {
            let tmp = {}
            Object.keys(json).forEach(e => {
                if (Array.isArray(json[e]))
                    tmp[e] = json[e].map(e => e)
                else if (json[e] instanceof Object)
                    tmp[e] = this.cloneJson(json[e])
                else tmp[e] = json[e]
            })
            return tmp
        },
        jsonWithoutNullable(json) {
            if (!json instanceof Object) return json
            if (Array.isArray(json))
                return json.map(e => this.jsonWithoutNullable(e))

            let tmp = {}
            Object.keys(json).forEach(k => {
                if (Array.isArray(json[k])) {
                    const tmp2 = this.jsonWithoutNullable(json[k])
                    if (tmp2.length > 0) tmp[k] = tmp2
                } else if (json[k] instanceof Object) {
                    const tmp2 = this.jsonWithoutNullable(json[k])
                    if (Object.keys(tmp2).length > 0) tmp[k] = tmp2
                } else if (json[k] != null && (json[k] + "").length > 0) tmp[k] = json[k]
            })
            return tmp;
        }
    }
}

