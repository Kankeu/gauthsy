<template>
    <v-hover v-slot:default="{hover}">
        <v-card :elevation="hover?12:0"  :height="height" :width="width">
            <v-img :height="height" :width="width" :src="url" v-if="opt(value).file||opt(value).path">
                <v-overlay absolute>
                    <v-layout align-center justify-center>
                        <v-btn @click="select" color="accent" icon>
                            <v-icon>edit</v-icon>
                        </v-btn>
                        <v-btn v-if="clearable||(resettable&&value.file!=null)" @click="$emit('input', resettable?initialValue:null)" color="error" icon>
                            <v-icon>delete</v-icon>
                        </v-btn>
                    </v-layout>
                    <v-file-input
                        v-show="false"
                        accept="image/*"
                        :rules="rules"
                        ref="input"
                        :value="value.file"
                        @change="change"
                    />
                </v-overlay>
            </v-img>

            <v-btn v-else :height="height" :width="width" :color="hover?null:'secondary'" outlined @click="select">
                <v-icon large>add</v-icon>
                <v-file-input
                    v-show="false"
                    accept="image/*"
                    :rules="rules"
                    ref="input"
                    :value="opt(value).file"
                    @change="change"
                />
            </v-btn>
        </v-card>
    </v-hover>
</template>

<script>
    export default {
        props:{
            value:{
                type: Object
            },
            clearable:{
                type: Boolean,
                default: false
            },
            resettable:{
                type: Boolean,
                default: false
            },
            rules:{
                type:Array
            },
            width:{
                type: String,
                default: '100'
            },
            height:{
                type: String,
                default: '100'
            },
            maxSize:{
                type: String
            }
        },
        data:()=>({
            errors:[],
            initialValue: null
        }),
        computed:{
            url() {
                if(this.value.path)
                    return this.$options.filters.fullPath(this.value.path)
                const URL =
                    window.URL && window.URL.createObjectURL
                        ? window.URL
                        : window.webkitURL && window.webkitURL.createObjectURL
                        ? window.webkitURL
                        : null
                return URL.createObjectURL(this.opt(this.value).file)
            },
        },
        methods: {
            select() {
                this.$refs.input.$el.querySelector('input').click()
            },
            change(e) {
                if(e&&e.size/1024>this.maxSize) {
                    this.$snackbar({
                        color:'error',
                        text: "The file must be smaller than " +max+" KB",
                    })
                    this.$refs.input.$el.querySelector('input').value=null
                    return
                }

                this.$emit('input', e==null?null:{file:e})
            }
        },
        mounted() {
            this.initialValue = this.value
        },
        watch:{
            value(){
                if(this.opt(this.value).path!=null)
                this.initialValue = this.value
            }
        }
    }
</script>
