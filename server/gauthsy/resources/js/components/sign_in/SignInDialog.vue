<template>
    <v-dialog hide-overlay persistent :value="value" @input="v=>$emit('input',v)" max-width="350">
        <v-card light class="align-self-center">
            <v-card-title>
                Sign In
                <v-spacer></v-spacer>
                <v-btn icon @click="popQuery('sign_in')">
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
                    <v-alert class="mt-3" type="info" outlined v-if="hasRetrieve">
                        Sign in to share your data with
                        <v-btn link text small target="_blank" :href="origin">{{ origin }}</v-btn>
                    </v-alert>
                    <MApolloMutation

                        :error-messages="{'auth:4':'Email or password invalid'}"
                        v-slot:props="{mutate,loading}"
                        :mutation="require('@graphql/auth').LOGIN">
                        <v-form ref="form" class="mt-3">
                            <v-layout column>
                                <v-flex md12>
                                    <v-text-field
                                        required
                                        label="Email"
                                        maxlength="30"
                                        @keyup.13="login(mutate)"
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
                                        @keyup.13="login(mutate)"
                                        :rules="$validations.make('required','filled','minLength(6)')"
                                        label="Password"
                                        v-model.trim="form.password"
                                    ></v-text-field>
                                </v-flex>
                                <v-flex md12 class="mb-3">
                                    <v-layout>
                                        <v-spacer></v-spacer>
                                        <v-btn text small link color="primary"
                                               @click="pushQuery({forgot_password: '1'})">
                                            forgot password?
                                        </v-btn>
                                    </v-layout>
                                </v-flex>
                                <v-flex md12>
                                    <v-layout>
                                        <v-btn color="accent" @click="pushQuery({sign_up: '1'})" link text depressed>
                                            Create
                                            account
                                        </v-btn>
                                        <v-spacer></v-spacer>

                                        <v-btn color="primary" @click="login(mutate)" :loading="loading" depressed>Sign
                                            In
                                        </v-btn>
                                    </v-layout>
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
        value: {type: Boolean, default: false},
    },
    data: () => ({
        form: {
            email: null,
            password: null,
        }
    }),
    computed: {
        hasRetrieve() {
            return this.$route.query.retrieve != null && this.$route.query.retrieve.length > 0
        },
        origin() {
            return this.$route.query.redirect
        }
    },
    methods: {
        login(mutate) {
            if (!this.$refs.form.validate())
                return this.$snackbar.show({text: 'Invalid form', color: 'error'})

            let form = {...this.form};
            console.log(form)
            mutate({
                variables: {data: form},
                update: (store, {data}) => {
                    console.log(data)
                    if (opt(data).login) {
                        this.form = {
                            email: null,
                            password: null,
                        }
                        if (data.login.me.email_verified_at == null)
                            this.$router.replace({...this.$route, query: {email_verification: data.login.me.id}})
                        else {
                            let name = this.$route.name
                            this.$repositories.auth.login(data.login)
                            if (name === 'starting' && name === this.$route.name) {
                                this.$router.push({name: 'home'})
                            }
                        }
                    } else {
                        this.$snackbar.show({
                            text: "Email or password invalid",
                            color: 'error',
                        })
                    }
                }
            })
        }
    },
    watch: {
        value(v) {
            if (v && this.$refs.form != null) this.$nextTick(_ => {
                this.$refs.form.reset()
            })
        }
    }
}
</script>
