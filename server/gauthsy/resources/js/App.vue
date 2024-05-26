<template>
    <v-app
        class="overflow-y-auto"
        style="position: relative"
        v-scroll="onScroll"
    >
        <!--<transition :name="transitionName">
            <router-view></router-view>
        </transition>-->
        <router-view style="height:100%"></router-view>
        <Footer></Footer>
        <v-fab-transition>
            <v-btn fab
                   color="accent darken-4"
                   style="z-index: 6"
                   bottom
                   :small="$vuetify.breakpoint.xsOnly"
                   fixed
                   right v-if="toTop" @click="$vuetify.goTo('body')">
                <v-icon>expand_less</v-icon>
            </v-btn>
        </v-fab-transition>
        <v-snackbar
            v-model="snackbar.opened"
            :timeout="snackbar.timeout"
            top
            :color="snackbar.color||'info'"
            elevation="24"
        >
            <v-layout justify-space-between align-center>
                <div style="font-weight: 700">
                    {{ snackbar.text }}
                </div>
                <v-btn
                    small
                    icon
                    @click="snackbar.opened=false"
                >
                    <v-icon>close</v-icon>
                </v-btn>
            </v-layout>

        </v-snackbar>
        <SignInDialog v-model="signInDialog"></SignInDialog>
        <SignUpDialog v-model="signUpDialog"></SignUpDialog>
        <DownloadDialog v-model="downloadDialog"></DownloadDialog>
        <EditProfileDialog v-model="editProfileDialog"></EditProfileDialog>
        <ForgotPasswordDialog v-model="forgotPasswordDialog"></ForgotPasswordDialog>
        <ResetPasswordDialog v-model="resetPasswordDialog"></ResetPasswordDialog>
        <EmailVerificationDialog v-model="emailVerificationDialog"></EmailVerificationDialog>
    </v-app>
</template>
<script>
import SignInDialog from "@components/sign_in/SignInDialog";
import Footer from "@components/footer/Footer";
import SignUpDialog from "./components/sign_up/SignUpDialog";
import ForgotPasswordDialog from "./components/forgot_password/ForgotPasswordDialog";
import EmailVerificationDialog from "./components/email_verification/EmailVerificationDialog";
import ResetPasswordDialog from "./components/reset_password/ResetPasswordDialog";
import DownloadDialog from "./components/download/DownloadDialog";
import EditProfileDialog from "./components/user/EditProfileDialog";

export default {
    components: {
        EditProfileDialog,
        DownloadDialog,
        ResetPasswordDialog,
        EmailVerificationDialog,
        ForgotPasswordDialog,
        SignUpDialog,
        Footer,
        SignInDialog,
    },
    data: () => ({
        toTop: false,
        snackbar: {
            text: null,
            opened: false,
        }
    }),
    computed: {
        signInDialog: {
            get() {
                return this.$route.query.sign_in === "1"
            },
            set(v) {
                if (v) this.pushQuery({sign_in: "1"})
                else this.popQuery('sign_in')
            }
        },
        forgotPasswordDialog: {
            get() {
                return this.$route.query.forgot_password === "1"
            },
            set(v) {
                if (v) this.pushQuery({forgot_password: "1"})
                else this.popQuery('forgot_password')
            }
        },
        resetPasswordDialog: {
            get() {
                return Object.keys(this.$route.query).includes('reset_password')
            },
            set(v) {
                if (v) this.pushQuery({reset_password: "1"})
                else this.popQuery('reset_password')
            }
        },
        signUpDialog: {
            get() {
                return this.$route.query.sign_up === "1"
            },
            set(v) {
                if (v) this.pushQuery({sign_up: "1"})
                else this.popQuery('sign_up')
            }
        },
        emailVerificationDialog: {
            get() {
                return Object.keys(this.$route.query).includes('email_verification')
            },
            set(v) {
                if (v != null) this.pushQuery({email_verification: v})
                else this.popQuery('email_verification')
            }
        },
        downloadDialog: {
            get() {
                return this.$route.query.download === "1"
            },
            set(v) {
                if (v) this.pushQuery({download: "1"})
                else this.popQuery('download')
            }
        },
        editProfileDialog: {
            get() {
                return this.$route.query.edit_profile === "1"
            },
            set(v) {
                if (v) this.pushQuery({edit_profile: "1"})
                else this.popQuery('edit_profile')
            }
        },
    },
    methods: {
        onScroll(e) {
            this.toTop = e.target.documentElement.scrollTop >= 500
        },
    },
    mounted() {
        this.$snackbar.listen(({text, color, timeout}) => {
            if (text == null) this.snackbar.opened = false
            else {
                this.snackbar.text = text
                this.snackbar.color = color || 'info'
                this.snackbar.opened = false
                this.snackbar.timeout = timeout || 3000
                this.$nextTick(() => this.snackbar.opened = true)
            }
        })
        this.$repositories.auth.init(this)
        this.$managers.em.attach("logged_in", _ => this.signInDialog = false)
    },
}
</script>


<style>
*{
    word-wrap: break-word;
}
#app {
    font-family: "Avenir", Helvetica, Arial, sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    color: #2c3e50
}

.theme--light.v-card {
    color: #2c3e50;
}

/*.theme--light.v-application{
    background: #f4f6f9 !important;
}*/
html {
    overflow-x: hidden !important;
}

.notification-title {
    font-size: 18px;
}

.notification-content {
    font-size: 16px;
}

/* width */
::-webkit-scrollbar {
    width: 10px;
}

/* Track */
::-webkit-scrollbar-track {
    background: #f1f1f1;
}

/* Handle */
::-webkit-scrollbar-thumb {
    background: #888;
}

/* Handle on hover */
::-webkit-scrollbar-thumb:hover {
    background: #555;
}

.max-lines {
    overflow: hidden;
    display: -webkit-box;
    -webkit-box-orient: vertical;
    text-overflow: ellipsis
}
</style>
