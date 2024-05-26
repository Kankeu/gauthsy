<template>
    <v-dialog hide-overlay persistent :value="value" @input="v=>$emit('input',v)" max-width="350">
        <v-card light class="align-self-center">
            <v-card-title>
                Password Forgot
                <v-spacer></v-spacer>
                <v-btn icon @click="popQuery('forgot_password')">
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
                    <MApolloMutation v-slot:props="{mutate,loading}"
                                     :mutation="require('@graphql/auth').FORGOT_PASSWORD">
                        <v-form @submit.prevent.stop="send(mutate)" ref="form" class="mt-3">
                            <v-layout column>
                                <v-flex md12>
                                    <v-text-field
                                        required
                                        label="Email"
                                        maxlength="30"
                                        :rules="$validations.make('required','filled','email','maxLength(30)')"
                                        v-model.trim="form.email"
                                        type="email"
                                    ></v-text-field>
                                </v-flex>
                                <v-flex md12 class="mt-3">
                                    <v-btn color="primary" block @click="send(mutate)" :loading="loading" depressed>send
                                        verification code
                                    </v-btn>
                                </v-flex>
                            </v-layout>
                        </v-form>
                    </MApolloMutation>

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
    data: () => ({
        form: {
            email: null,
        }
    }),
    methods: {
        send(mutate) {
            if (!this.$refs.form.validate())
                return this.$snackbar.show({text: 'Invalid form', color: 'error'})

            let form = {...this.form};
            console.log(form)
            mutate({
                variables: {data: form},
                update: (store, {data}) => {
                    console.log(data)
                    if (opt(data).forgotPassword) {
                        this.$snackbar.show({
                            text: "We have sent you an account recovery email, please check your mailbox to reset your password",
                            color: 'success',
                            timeout: 9000
                        })
                        this.form = {
                            email: null,
                        }
                        this.$router.replace({...this.$route, query: {reset_password: ''}})
                    }
                }
            })
        }
    },
    watch: {
        value(v) {
            if (v) {
                this.$nextTick(_ => {
                    this.$refs.form.reset()
                })
            }
        }
    }
}
</script>
