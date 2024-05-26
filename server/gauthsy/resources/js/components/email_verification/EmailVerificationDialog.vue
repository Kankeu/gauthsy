<template>
    <v-dialog hide-overlay :value="value" @input="v=>$emit('input',v)" max-width="350">
        <v-card light class="align-self-center">
            <v-card-title>
                Email Verification
                <v-spacer></v-spacer>
                <v-btn icon @click="popQuery('email_verification')">
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
                    <v-form ref="form" class="mt-3">
                        <v-layout column>
                            <v-flex md12 class="mb-3">
                                <v-text-field
                                    required
                                    label="Token (last part of confirmation link)"
                                    maxlength="30"
                                    :rules="$validations.make('required','filled')"
                                    v-model.trim="token"
                                    type="text"
                                ></v-text-field>
                            </v-flex>
                            <v-flex md12 class="mb-3">
                                <v-layout>
                                    <v-spacer></v-spacer>
                                    <MApolloMutation v-slot:props="{mutate,loading}"
                                                     :mutation="require('@graphql/auth').RESENT_EMAIL_VERIFIED">
                                        <v-btn text small link color="primary" :loading="loading"
                                               @click="resent(mutate)">Resent
                                            Verification email
                                        </v-btn>
                                    </MApolloMutation>
                                </v-layout>
                            </v-flex>
                            <v-flex md12>
                                <MApolloMutation v-slot:props="{mutate,loading}"
                                                 :mutation="require('@graphql/auth').VERIFY_EMAIL">
                                    <v-btn ref="button" color="primary" block @click="verify(mutate)" :loading="loading"
                                           depressed>
                                        Verify
                                    </v-btn>
                                </MApolloMutation>
                            </v-flex>
                        </v-layout>
                    </v-form>
                </v-layout>
            </v-card-text>
        </v-card>
    </v-dialog>
</template>

<script>

export default {
    props: {
        link: {type: Boolean, default: false},
        value: {type: Boolean, default: false},
    },
    data: () => ({}),
    computed: {
        id() {
            let parts = (this.$route.query.email_verification || '').split(":")
            if (parts.length < 1) return null
            return parts[0]
        },
        token() {
            let parts = (this.$route.query.email_verification || '').split(":")
            if (parts.length < 2) return null
            return parts[1]
        }
    },
    methods: {
        resent(mutate) {
            if (this.id == null)
                return this.$snackbar.show({text: 'Invalid url', color: 'error'})

            mutate({
                variables: {data: {id: this.id}},
                update: (store, {data}) => {
                    console.log(data)
                    if (opt(data).resentEmailVerified) {
                        this.$snackbar.show({
                            text: "Email resent",
                            color: 'success',
                        })
                    }
                }
            })
        },
        verify(mutate) {
            if (!this.$refs.form.validate())
                return this.$snackbar.show({text: 'Invalid form', color: 'error'})

            let form = {token: this.token};
            console.log(form)
            mutate({
                variables: {data: form},
                update: (store, {data}) => {
                    console.log(data)
                    if (opt(data).verifyEmail) {
                        this.$snackbar.show({
                            text: "Email verified",
                            color: 'success',
                        })
                        this.$refs.form.reset()
                        this.$router.replace({...this.$route, query: {sign_in: '1'}})
                    }
                }
            })
        }
    },
    watch: {
        value(v) {
            if (v) {
                this.$nextTick(_ => {
                    if (this.$refs.form.validate())
                        this.$refs.button.$el.click();
                })
            }
        }
    }
}
</script>
