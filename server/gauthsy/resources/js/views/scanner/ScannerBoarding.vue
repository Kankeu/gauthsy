<template>
    <v-layout column>
        <v-app-bar
            fixed
            color="white"
            elevate-on-scroll
        >
            <v-toolbar-title class="headline font-weight-bold">

                <v-btn @click="$router.back()" icon>
                    <v-icon>arrow_back</v-icon>
                </v-btn>&nbsp;{{ $config.appName }}
            </v-toolbar-title>

            <v-spacer></v-spacer>
            <v-toolbar-title class="headline font-weight-bold">
                Scanning steps
            </v-toolbar-title>

        </v-app-bar>
        <v-sheet height="100"></v-sheet>
        <v-layout class="px-sm-0">
            <v-flex lg4 sm3></v-flex>
            <v-flex lg4 sm6>
                <v-card class="text-center" flat>
                    <v-layout align-center column justify-center>
                        <v-card-title class="headline font-weight-bold">If you are on a desktop or laptop, make sure you have a good camera, otherwise use a smartphone.</v-card-title>
                        <v-card-title>Photograph your ID</v-card-title>
                        <v-img contain height="200" width="200" src="/images/defaults/boarding2.png"></v-img>
                        <v-card-title>Take a selfie</v-card-title>
                        <v-img contain height="200" width="200" src="/images/defaults/boarding3.png"></v-img>
                        <v-card-title>An agent will verify your ID and notify you</v-card-title>
                        <v-img contain height="200" width="200" src="/images/defaults/boarding1.png"></v-img>
                        <div style="width: 100%;" class="px-6 ">
                            <v-overflow-btn
                                class="my-2"
                                :items="countries[$route.query.type]"
                                style="width: 100%"
                                label="Select the country"
                                v-model="country"
                                return-object
                                item-value="text"
                            ></v-overflow-btn>
                            <v-btn block :disabled="country==null" @click="start" depressed color="accent">Ok, I am ready
                            </v-btn>
                        </div>
                        <v-sheet height="20"></v-sheet>
                    </v-layout>
                </v-card>
            </v-flex>
            <v-flex lg4 sm3></v-flex>
        </v-layout>
    </v-layout>
</template>

<script>
export default {
    data: () => ({
        country: null
    }),
    computed: {
        countries() {
            return {
                AR: [{value: 'DE', text: 'Germany'}],
                ID: [{value: 'CM', text: 'Cameroon'}, {value: 'DE', text: 'Germany'}, {value: 'RW', text: 'Rwanda'}],
            }
        }
    },
    methods: {
        start() {
            console.log(this.country)
            this.$router.push({name: 'scanner', query: {issued_by: this.country.value, type: this.$route.query.type}})
        }
    }
}
</script>
