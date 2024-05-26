<template>
    <v-dialog hide-overlay persistent :value="value" @input="v=>$emit('input',v)" max-width="350">
        <v-card light class="align-self-center">
            <v-card-title>
                Sign Up
                <v-spacer></v-spacer>
                <v-btn icon @click="popQuery('sign_up')">
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
                            <v-flex md12>
                                <v-text-field
                                    required
                                    label="Forename"
                                    maxlength="30"
                                    :rules="$validations.make('required','filled','maxLength(30)')"
                                    v-model.trim="form.forename"
                                    type="text"
                                ></v-text-field>
                            </v-flex>
                            <v-flex md12>
                                <v-text-field
                                    required
                                    label="Surname"
                                    maxlength="30"
                                    :rules="$validations.make('required','filled','maxLength(30)')"
                                    v-model.trim="form.surname"
                                    type="text"
                                ></v-text-field>
                            </v-flex>
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
                            <v-flex md12>
                                <v-text-field
                                    required
                                    type="password"
                                    minlength="6"
                                    :rules="$validations.make('required','filled','minLength(6)')"
                                    label="Password"
                                    v-model.trim="form.password"
                                ></v-text-field>
                            </v-flex>
                            <v-flex md12>
                                <v-text-field
                                    required
                                    type="password"
                                    minlength="6"
                                    :rules="$validations.make('required','filled','minLength(6)','confirmed('+form.password+')')"
                                    label="Confirm Password"
                                ></v-text-field>
                            </v-flex>
                            <v-flex md12 class="mb-3">
                                <v-layout>
                                    <v-checkbox :rules="$validations.make('required')">
                                        <template v-slot:label>
                                            &nbsp; I accept &nbsp;
                                            <v-btn text small @click="pushQuery({privacy_policy: '1'})" link color="primary">the privacy policy</v-btn>
                                        </template>
                                    </v-checkbox>
                                    <v-spacer></v-spacer>
                                </v-layout>
                            </v-flex>
                            <v-flex md12>
                                <MApolloMutation only-validation-errors
                                                 v-slot:props="{mutate,loading}"
                                                 :mutation="require('@graphql/auth').SIGN_UP">
                                    <v-btn color="primary" block @click="signUp(mutate)" :loading="loading" depressed>Sign
                                        Up
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
        value: {type: Boolean, default: false},
    },
    data: () => ({
        form: {
            forename: null,
            surname: null,
            email: null,
            password: null,
        }
    }),
    methods: {
        signUp(mutate) {
            if (!this.$refs.form.validate())
                return this.$snackbar.show({text: 'Invalid form', color: 'error'})

            let form = {...this.form};
            console.log(form)
            mutate({
                variables: {data: form},
                update: (store, {data}) => {
                    console.log(data)
                    if (opt(data).signUp) {
                        this.$snackbar.show({
                            text: "Email verification sent. \nCheck your mailbox.",
                            color: 'success',
                            timeout: 10000
                        })
                        this.form = {
                            forename: null,
                            surname: null,
                            email: null,
                            password: null,
                        }
                        this.$router.replace({...this.$route, query: {email_verification: data.signUp.id}})
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
