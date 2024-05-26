<template>
    <v-dialog hide-overlay persistent :value="value" @input="v=>$emit('input',v)" max-width="350">
        <v-card light class="align-self-center">
            <v-card-title>
                Reset Password
                <v-spacer></v-spacer>
                <v-btn icon @click="popQuery('reset_password')">
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
                                     :mutation="require('@graphql/auth').RESET_PASSWORD">
                        <v-form ref="form" class="mt-3">
                            <v-layout column>
                                <v-flex md12>
                                    <v-text-field
                                        required
                                        type="password"
                                        minlength="6"
                                        @keyup.13="reset(mutate)"
                                        :rules="$validations.make('required','filled','minLength(6)')"
                                        label="New Password"
                                        v-model.trim="form.password"
                                    ></v-text-field>
                                </v-flex>
                                <v-flex md12>
                                    <v-text-field
                                        required
                                        type="password"
                                        minlength="6"
                                        @keyup.13="reset(mutate)"
                                        :rules="$validations.make('required','filled','minLength(6)','confirmed('+form.password+')')"
                                        label="Confirm New Password"
                                    ></v-text-field>
                                </v-flex>
                                <v-flex md12>
                                    <v-text-field
                                        required
                                        label="Token (last part of confirmation link)"
                                        maxlength="30"
                                        @keyup.13="reset(mutate)"
                                        :rules="$validations.make('required','filled')"
                                        v-model.trim="confirmationLink"
                                        type="text"
                                    ></v-text-field>
                                </v-flex>
                                <v-flex md12 class="mt-3">
                                    <v-btn color="primary" block @click="reset(mutate)" :loading="loading" depressed>
                                        reset password
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
            token: null,
            password: null
        }
    }),
    computed: {
        confirmationLink: {
            get() {
                return this.$route.query.reset_password
            },
            set(v) {
                if (v != null) this.pushQuery({reset_password: v})
                else this.popQuery('reset_password')
            }
        }
    },
    methods: {
        reset(mutate) {
            if (!this.$refs.form.validate())
                return this.$snackbar.show({text: 'Invalid form', color: 'error'})

            let form = {token: this.confirmationLink.split("/").reverse()[0], password: this.form.password};
            console.log(form)
            mutate({
                variables: {data: form},
                update: (store, {data}) => {
                    console.log(data)
                    if (opt(data).resetPassword) {
                        this.$snackbar.show({
                            text: "Your password has been successfully changed",
                            color: 'success',
                            timeout: 9000
                        })
                        this.form = {
                            token: null,
                            password: null,
                        }
                        this.confirmationLink = null;
                        this.$router.replace({...this.$route, query: {sign_in: '1'}})
                    }
                }
            })
        }
    },
    watch: {
        value(v) {
            if (!v) {
                this.$nextTick(_ => {
                    this.$refs.form.reset()
                })
            }
        }
    }
}
</script>
