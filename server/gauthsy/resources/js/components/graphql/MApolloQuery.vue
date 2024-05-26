<template>
    <div :style="height?('height:'+height):''" :class="containerClassName">
        <div v-intersect="(e,o)=>onIntersect(e,o,$apollo.queries.data)" style="height: 100px;"
             v-if="reverse&&(!$apollo.queries.data.loading&&!starting)&&fetchMore&&hasMore"></div>
        <v-layout align-center justify-center v-else-if="reverse&&hasMore&&loading">
            <v-progress-circular size="50" color="primary" indeterminate class="mt-5 mb-5"></v-progress-circular>
        </v-layout>
        <slot name="loading" v-bind:loading="loading" v-if="!$scopedSlots.props&&loading">
            <v-layout column align-center justify-center>
                <v-progress-circular
                    :size="50"
                    color="primary"
                    indeterminate
                ></v-progress-circular>
            </v-layout>
        </slot>
        <slot name="error" v-bind:error="error" v-if="!$scopedSlots.props&&error">
            <v-layout column align-center justify-center>
                <v-card
                    height="230"
                    width="400"
                    class="pa-3"

                >
                    <v-layout justify-center column align-center>
                        <v-icon size="100">sentiment_very_dissatisfied</v-icon>
                        <v-card-title>Whoops something went wrong!</v-card-title>
                        <v-btn block color="accent" depressed @click="refetch">Try again</v-btn>
                    </v-layout>
                </v-card>
            </v-layout>
        </slot>
        <slot name="data" v-bind:data="data" v-bind:refetch="refetch" v-if="!$scopedSlots.props"></slot>
        <NotFound :refetch="refetch" v-else-if="notFound&&!loading&&!hasData(data, notFound)"></NotFound>
        <slot name="no-data" :refetch="refetch" v-else-if="noData&&!loading&&!hasData(data, noData)"></slot>
        <slot name="props" :refetch="refetch" :loading="loading&&!hasMore" :query="$apollo.queries.data" :error="error"
              :data="data"
              v-else></slot>
        <div v-intersect="(e,o)=>onIntersect(e,o,$apollo.queries.data)" style="height: 100px;"
             v-if="!reverse&&(!$apollo.queries.data.loading)&&fetchMore&&hasMore"></div>
        <v-layout align-center justify-center v-else-if="!reverse&&hasMore&&loading">
            <v-progress-circular size="50" color="primary" indeterminate class="mt-5 mb-5"></v-progress-circular>
        </v-layout>
        <div id="scroll-bottom"></div>
    </div>
</template>

<script>
import NotFound from "./NotFound";

export default {
    components: {NotFound},
    props: {
        query: {type: Object, require: true},
        variables: {type: Object},
        first: {type: Number, default: 10},
        page: {type: Number, default: 1},
        fetchMore: {type: Boolean, default: false},
        reverse: {type: Boolean, default: false},
        fetchPolicy: {type: String, default: 'cache-and-network'},
        skip: {type: Boolean, default: false},
        pollInterval: {type: Array, default: null},
        update: {type: Function},
        noData: {type: String},
        notFound: {type: String},
        height: {type: Number | String},
        containerClassName: {type: String},
        loaderType: {
            type: String,
        },
    },
    data: () => ({
        lock: false,
        starting: true,
        counter: 0,
        currentPage: null,
        hasMorePages: null,
        lastScrollHeight: null
    }),
    computed: {
        hasMore() {
            let helper = (e) => {
                const keys = Object.keys(e)
                for (let i = 0; i < keys.length; i++) {
                    let k = keys[i]
                    if (e[k] instanceof Object) return helper(e[k])
                    if (e[k] === true) return true;
                }
                return false;
            }
            return this.hasMorePages != null && helper(this.hasMorePages)
        },
        loading() {
            return this.$apollo.queries.data.loading
        },
        error() {
            return this.$apollo.queries.data.errorHandler()
        }
    },
    created() {
        this.currentPage = this.page
        this.setPollInterval()
        this.$apollo.queries.data.setOptions({
            fetchPolicy: this.fetchPolicy
        })
    },
    apollo: {
        data: {
            skip() {
                return this.skip
            },
            query() {
                return this.query
            },
            fetchPolicy() {
                return this.fetchPolicy
            },
            variables() {
                return {first: this.first, page: this.page, ...this.variables}
            },
            update(d) {
                this.hasMorePages = this.extractHasMorePages(d, true)
                this.counter++
                setTimeout(() => {
                    this.$nextTick(() => {
                        this.counter--
                        if (this.counter === 0)
                            this.starting = false
                    })
                }, 500)
                if (this.update != null) this.update(d)
                return d
            }
        }
    },
    methods: {
        hasData(data, keys) {
            if (data == null)
                return false
            data = JSON.parse(JSON.stringify(data))
            let parts = keys.split('.')

            for (let part of parts) {
                if (data[part] == null) return false
                data = data[part]
            }
            return data instanceof Array ? data.length > 0 : data != null
        },
        setPollInterval() {
            if (Array.isArray(this.pollInterval)) {
                if (this.pollInterval.length === 1) this.$apollo.queries.data.startPolling(this.pollInterval[0] * 1000)
                if (this.pollInterval.length === 2) this.$apollo.queries.data.startPolling((Math.random() * (this.pollInterval[1] - this.pollInterval[0]) + this.pollInterval[0]) * 1000)
            } else {
                this.$apollo.queries.data.stopPolling()
            }
        },
        refetch(variables) {
            if(variables instanceof Event) variables=null
            this.$apollo.queries.data.setOptions({
                fetchPolicy: 'network-only'
            })
            console.log(variables, this.variables)

            this.$apollo.queries.data.refetch({first: this.first, page: this.currentPage, ...(variables||this.variables)})
        },
        updateCache(previousResult, data) {
            if (data == null) return previousResult
            this.hasMorePages = this.extractHasMorePages(data.fetchMoreResult)

            let tmp = this.mergeJson(previousResult, data.fetchMoreResult, this.hasMorePages)
            console.log(previousResult, data.fetchMoreResult, JSON.parse(JSON.stringify(tmp)))

            this.currentPage++
            setTimeout(() => {
                this.lock = false
                this.$nextTick(() => {
                    if (this.lastScrollHeight && (this.$el.scrollTop < (this.$el.scrollHeight - this.$el.offsetHeight))) {
                        console.log(this.$el.scrollHeight, this.lastScrollHeight)
                        this.$el.scrollTop = this.$el.scrollHeight - this.lastScrollHeight
                    }
                })
            }, 100)

            return tmp
        },
        onIntersect(entries, observer, query) {
            if (!entries[0].isIntersecting || this.lock || !this.hasMore) return;
            this.lock = true
            this.lastScrollHeight = this.$el.scrollHeight
            query.fetchMore({
                variables: {first: this.first, page: this.currentPage + 1, ...this.variables},
                updateQuery: this.updateCache
            })

        },
        mergeJson(json1, json2, map) {
            if (!(map instanceof Object)) {
                return {...json1, ...json2, data: json1.data.concat(json2.data)}
            }
            let tmp = json1
            Object.keys(map).forEach(k => {
                tmp[k] = this.mergeJson(json1[k], json2[k], map[k])
            })
            return tmp
        },
        extractHasMorePages(data, created = false) {
            let tmp = {}
            Object.keys(data).forEach(k => {
                if (k === 'hasMorePages')
                    tmp[k] = data['hasMorePages']
                else if (k === "currentPage" && created)
                    this.currentPage = data['currentPage']
                else if ((!Array.isArray(data[k])) && (data[k] instanceof Object)) tmp[k] = this.extractHasMorePages(data[k], created)
            })
            Object.keys(tmp).forEach(k => {
                if ((tmp[k] instanceof Object) && tmp[k]['paginatorInfo'] != null)
                    tmp[k] = tmp[k]['paginatorInfo']['hasMorePages']

            })
            return tmp
        },
        equalsJson(json1, json2) {
            return Object.keys(json1).find(k => {
                if (json1[k] instanceof Object && json2[k] instanceof Object) return this.equalsJson(json1[k], json2[k])
                return json1[k] !== json2[k]
            }) == null
        }
    },
    watch: {
        variables(v, altV) {
            if (v == null || altV == null || !this.equalsJson(v, altV)) {
                this.starting = true
                this.$el.scrollTop = this.$el.scrollHeight
            }
        },
        pollInterval() {
            this.setPollInterval()
        }
    }
}
</script>
