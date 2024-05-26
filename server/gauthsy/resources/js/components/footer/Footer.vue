<template>
    <v-layout column>
        <v-footer
            class="mt-5"
            :style="'z-index:6;max-width:'+(innerWidth-(!hasDrawer?0:266))+'px'"
            dark
            v-if="$route.name!=='splash'"
            padless>
            <v-card
                flat
                tile
                width="100%"
                class="blue-grey darken-4 white--text text-center"
            >
                <v-tabs
                    background-color="blue-grey darken-4"
                    v-model="tab" centered fixed-tabs>
                    <v-tab class="blue-grey darken-4 white--text" key="about_us">About us</v-tab>
                    <v-tab class="blue-grey darken-4 white--text" key="contact_us">Contact us</v-tab>
                    <v-tab class="blue-grey darken-4 white--text" key="team">Team</v-tab>
                </v-tabs>
                <v-divider></v-divider>
                <v-tabs-items v-model="tab" class="overflow-y-auto">
                    <v-tab-item key="about_us">
                        <AboutUs></AboutUs>
                    </v-tab-item>
                    <v-tab-item key="contact_us">
                        <ContactUs></ContactUs>
                    </v-tab-item>
                    <v-tab-item key="team">
                        <Team></Team>
                    </v-tab-item>
                </v-tabs-items>
                <v-divider></v-divider>
                <v-card-text class="white--text">
                    <v-layout class="pl-5 pr-5" justify-space-around align-center>
                        <div>
                            &copy;{{ year }} —
                            <strong>{{ $config.appName }}</strong>
                        </div>
                        <v-spacer></v-spacer>
                        <v-btn small color="accent" dark @click="privacyDialog" depressed>Private policy</v-btn>
                    </v-layout>
                </v-card-text>
            </v-card>
        </v-footer>
        <PrivacyPolicyDialog></PrivacyPolicyDialog>
    </v-layout>
</template>


<script>
import AboutUs from "./AboutUs.vue";
import ContactUs from "./ContactUs.vue";
import Team from "./Team.vue";
import PrivacyPolicyDialog from "@components/privacy_policy/PrivacyPolicyDialog"

export default {
    components: {AboutUs, ContactUs, Team, PrivacyPolicyDialog},
    data: () => ({
        tab: 0
    }),
    computed: {
        year() {
            return new Date().getFullYear();
        },
        hasDrawer() {
            return ['restaurant', 'mcf', 'ptc'].includes(this.$route.name) && !this.$vuetify.breakpoint.xsOnly
        },
    },
    methods: {
        privacyDialog() {
            this.pushQuery({privacy_policy: 1})
        }
    }
};
</script>
