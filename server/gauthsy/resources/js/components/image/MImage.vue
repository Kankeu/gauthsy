<template>
    <v-hover v-slot="{ hover }">
        <v-card @click="dialog=true" :elevation="hover?12:0" style="width: 100%;height: 100%">
            <v-img :contain="contains" :max-width="width" :max-height="height"
                   :src="image"></v-img>
            <v-dialog v-model="dialog" max-width="600">
                <v-card>
                    <v-card-title>Image
                        <v-spacer></v-spacer>
                        <v-btn @click="dialog=false" icon>
                            <v-icon>close</v-icon>
                        </v-btn>
                    </v-card-title>
                    <v-card-text>
                        <v-img :src="image" contain></v-img>
                    </v-card-text>
                </v-card>
            </v-dialog>
        </v-card>
    </v-hover>

</template>

<script>
export default {
    props: {
        src: {type: String, default: false},
        width: {type: String, default: "100"},
        height: {type: String, default: "100"},
        contains: {type: Boolean, default: false},
    },
    data: () => ({
        image: null,
        dialog: false
    }),
    computed: {
        headers() {
            return {Authorization: this.$repositories.auth.auth.token_type + " " + this.$repositories.auth.auth.access_token}
        },
    },
    mounted() {
        fetch(this.src, {headers: this.headers})
            .then(r => r.blob())
            .then(d => this.image = window.URL.createObjectURL(d))
    }
}
</script>
