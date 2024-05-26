<template>
    <v-dialog v-model="dialog" width="600px">
        <v-card>
            <v-card-title>
                <span class="headline">Use {{ $config.appName }}'s service?</span>
            </v-card-title>
            <v-card-text v-html="htmlPrivp"></v-card-text>
            <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn depressed @click="dialog = false">Disagree</v-btn>
                <v-btn color="success" depressed @click="agree">Agree</v-btn>
            </v-card-actions>
        </v-card>
    </v-dialog>
</template>

<script>
import HtmlPrivp from './privacy_policy'
export default {
    data() {
        return {
            dialog: false,
            htmlPrivp: HtmlPrivp.html
        };
    },
    methods: {
        agree() {
            this.dialog=false
        }
    },
    mounted() {
        if (this.$route.query.privacy_policy) {
            this.popQuery("privacy_policy")
        }
    },
    watch: {
        dialog(v) {
            if (!v) {
                this.popQuery("privacy_policy")
            }
        },
        "$route.query.privacy_policy"(value) {
            if (value) {
                this.dialog = true;
            } else {
                this.dialog = false;
            }
        }
    }
};
</script>
