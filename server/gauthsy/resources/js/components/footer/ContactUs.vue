<template>
    <v-card tile class="blue-grey darken-4 white--text text-center" flat>
        <v-layout>
            <v-flex md3 xs0 sm1></v-flex>
            <v-flex sm10 xs12 md6>
                <v-card-text>
                    <v-form ref="form">
                        <v-layout column>
                            <v-flex md12>
                                <v-text-field
                                    solo
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
                                    solo
                                    required
                                    maxlength="30"
                                    :rules="$validations.make('required','filled','maxLength(30)')"
                                    label="Full name"
                                    v-model.trim="form.full_name"
                                ></v-text-field>
                            </v-flex>
                            <v-flex md12>
                                <v-textarea
                                    counter="640"
                                    maxlength="640"
                                    solo
                                    :rules="$validations.make('required','filled','maxLength(640)')"
                                    label="Message"
                                    v-model.trim="form.message"
                                    required
                                ></v-textarea>
                            </v-flex>
                        </v-layout>
                    </v-form>
                    <v-layout>
                        <v-spacer></v-spacer>

                        <MApolloMutation v-slot:props="{mutate,loading}" :mutation="require('@graphql/contact').CREATE">
                            <v-btn color="accent" class="mr-0" :loading="loading" @click="send(mutate)" outlined>
                                Send
                                <v-icon right>send</v-icon>
                            </v-btn>
                        </MApolloMutation>
                    </v-layout>
                </v-card-text>
            </v-flex>
            <v-flex md3 xs0 sm1></v-flex>
        </v-layout>
    </v-card>
</template>

<script>
export default {
    data: () => ({
        form: {
            full_name: "",
            email: "",
            message: "",
        },
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
                    if (data.createContact) {
                        this.$snackbar.show({
                            text: "The " + this.$config.appName + "'s team thanks you for your message and promises you an answer as soon as possible.",
                            color: 'success',
                            timeout: 9000
                        })
                        this.form = {
                            full_name: "",
                            email: "",
                            message: "",
                        }
                        this.$refs.form.reset()
                    }
                }
            })
        }
    }
};
</script>

<style scoped>
.ls-5 {
    letter-spacing: 0.5px;
}
</style>
