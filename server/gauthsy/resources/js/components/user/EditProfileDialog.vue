<template>
    <v-dialog hide-overlay persistent :value="value" @input="v=>$emit('input',v)" max-width="400">
        <v-card light class="align-self-center">
            <v-card-title>
                Edit Profile
                <v-spacer></v-spacer>
                <v-btn icon @click="popQuery('edit_profile')">
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
                            <v-card class="pa-2 mb-3" style="border:1px solid #e2e2e2" flat>
                                <v-card-title class="pl-0 pt-0">Profile</v-card-title>
                                <v-form ref="basicForm">
                                    <v-text-field
                                        required
                                        label="Forename"
                                        maxlength="30"
                                        :rules="$validations.make('required','filled','maxLength(30)')"
                                        v-model.trim="form.forename"
                                        type="text"
                                    ></v-text-field>
                                    <v-text-field
                                        required
                                        label="Surname"
                                        maxlength="30"
                                        :rules="$validations.make('required','filled','maxLength(30)')"
                                        v-model.trim="form.surname"
                                        type="text"
                                    ></v-text-field>
                                    <MApolloMutation only-validation-errors
                                                     v-slot:props="{mutate,loading}"
                                                     :mutation="require('@graphql/auth').UPDATE_BASIC_PROFILE">
                                        <v-btn color="primary" block @click="updateBasicProfile(mutate)"
                                               :loading="loading" depressed>
                                            Save
                                        </v-btn>
                                    </MApolloMutation>
                                </v-form>
                            </v-card>
                            <v-card class="pa-2 mb-3" style="border:1px solid #e2e2e2" flat>
                                <v-card-title class="pl-0 pt-0">Address</v-card-title>
                                <v-form ref="addressForm">
                                    <v-text-field
                                        required
                                        label="Email"
                                        maxlength="30"
                                        :rules="$validations.make('required','filled','email','maxLength(30)')"
                                        v-model.trim="form.email"
                                        type="email"
                                    ></v-text-field>
                                    <MApolloMutation only-validation-errors
                                                     v-slot:props="{mutate,loading}"
                                                     :mutation="require('@graphql/auth').UPDATE_ADDRESSES">
                                        <v-btn color="primary" block @click="updateAddress(mutate)" :loading="loading"
                                               depressed>
                                            Save
                                        </v-btn>
                                    </MApolloMutation>
                                </v-form>
                            </v-card>
                            <v-card class="pa-2 mb-3" style="border:1px solid #e2e2e2" flat>
                                <v-card-title class="pl-0 pt-0">Password</v-card-title>
                                <v-form ref="passwordForm">
                                    <v-text-field
                                        required
                                        type="password"
                                        minlength="6"
                                        :rules="$validations.make('required','filled','minLength(6)')"
                                        label="Last Password"
                                        v-model.trim="form.lastPassword"
                                    ></v-text-field>
                                    <v-text-field
                                        required
                                        type="password"
                                        minlength="6"
                                        :rules="$validations.make('required','filled','minLength(6)')"
                                        label="Password"
                                        v-model.trim="form.password"
                                    ></v-text-field>
                                    <v-text-field
                                        required
                                        type="password"
                                        minlength="6"
                                        :rules="$validations.make('required','filled','minLength(6)','confirmed('+form.password+')')"
                                        label="Confirm New Password"
                                    ></v-text-field>
                                    <MApolloMutation only-validation-errors
                                                     v-slot:props="{mutate,loading}"
                                                     :mutation="require('@graphql/auth').UPDATE_PASSWORD">
                                        <v-btn color="primary" block @click="updatePassword(mutate)" :loading="loading"
                                               depressed>
                                            Save
                                        </v-btn>
                                    </MApolloMutation>
                                </v-form>
                            </v-card>
                            <MApolloMutation only-validation-errors
                                             v-slot:props="{mutate,loading}"
                                             :mutation="require('@graphql/auth').REVOKE_ALL_TOKENS">
                            <v-tooltip top>
                                <template v-slot:activator="{attrs,on}">
                                    <v-btn depressed @click="updateTokens(mutate)" :loading="loading" v-on="on" v-bind="attrs" class="my-3" color="primary">Logout all the connected devices</v-btn>
                                </template>
                                <span>You can use it, if you want to prevent a stranger from using your lost device to access your account</span>
                            </v-tooltip>
                            </MApolloMutation>
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
            lastPassword: null,
            password: null,
        }
    }),
    methods: {
        updateBasicProfile(mutate) {
            if (!this.$refs.basicForm.validate())
                return this.$snackbar.show({text: 'Invalid form', color: 'error'})

            let form = {surname: this.form.surname, forename: this.form.forename};
            console.log(form)
            mutate({
                variables: {data: form},
                update: (store, {data}) => {
                    console.log(data)
                    if (opt(data).updateUser) {
                        this.$snackbar.show({
                            text: "Updated",
                            color: 'success'
                        })
                        this.$repositories.auth.user = {...data.updateUser}
                    }
                }
            })
        },
        updateAddress(mutate) {
            if (!this.$refs.addressForm.validate())
                return this.$snackbar.show({text: 'Invalid form', color: 'error'})

            let form = {email: this.form.email};
            console.log(form)
            mutate({
                variables: {data: form},
                update: (store, {data}) => {
                    console.log(data)
                    if (opt(data).updateUser) {
                        this.$snackbar.show({
                            text: "Verification email sent. \nCheck your mailbox.",
                            color: 'success',
                            timeout: 10000
                        })
                    }
                }
            })
        },
        updatePassword(mutate) {
            if (!this.$refs.passwordForm.validate())
                return this.$snackbar.show({text: 'Invalid form', color: 'error'})

            let form = {last_password: this.form.lastPassword, password: this.form.password};
            console.log(form)
            mutate({
                variables: {data: form},
                update: (store, {data}) => {
                    console.log(data)
                    if (opt(data).updateUser) {
                        this.$snackbar.show({
                            text: "Updated",
                            color: 'success',
                        })
                    }
                }
            })
        },
        updateTokens(mutate) {
            mutate({
                update: (store, {data}) => {
                    console.log(data)
                    if (opt(data).revokeAllTokens) {
                        this.$snackbar.show({
                            text: "Done",
                            color: 'success',
                        })
                        this.$repositories.auth.logout()
                    }
                }
            })
        }
    },
    watch: {
        value(v) {
            if (v) {
                this.form.surname = this.$repositories.auth.user.surname
                this.form.forename = this.$repositories.auth.user.forename
                this.form.email = this.$repositories.auth.user.email
            }
        }
    }
}
</script>
