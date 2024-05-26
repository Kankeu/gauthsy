<template>
    <v-dialog hide-overlay persistent :value="value" @input="v=>$emit('input',v)" max-width="350">
        <v-card light class="align-self-center">
            <v-card-title>
                Mobile App
                <v-spacer></v-spacer>
                <v-btn icon @click="popQuery('download')">
                    <v-icon>close</v-icon>
                </v-btn>
            </v-card-title>
            <v-card-text>
                <v-layout column fill-height justify-center>
                    <v-avatar
                        class="align-self-center"
                        size="100">
                        <v-img
                            :src="$config.images.logo">
                        </v-img>
                    </v-avatar>
                </v-layout>
                <v-layout column fill-height justify-center>
                    <v-card-title>Download the application for Android</v-card-title>
                    <v-btn large block color="primary" @click="download" depressed>Download apk</v-btn>
                </v-layout>
            </v-card-text>
        </v-card>
    </v-dialog>
</template>

<script>
import download  from "downloadjs"
export default {
    props: {
        value: {type: Boolean, default: false},
    },
    methods:{
        download(){
            download("/app/gauthsy.apk")
            this.popQuery('download')
        }
    }
}
</script>
