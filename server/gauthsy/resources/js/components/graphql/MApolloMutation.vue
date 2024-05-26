<template>
    <ApolloMutation :optimistic-response="optimisticResponse" :mutation="mutation" :update="update"
                    :variables="variables" @done="$emit('done')"
                    v-slot="{ mutate, loading, error, errors }">
        <slot name="loading" v-bind:loading="loading" v-if="!$scopedSlots.props">
            <v-progress-circular
                :size="50"
                color="primary"
                indeterminate
                v-if="loaderType==='normal'"
            ></v-progress-circular>
            <v-dialog
                v-model="loading"
                overlay-opacity=".5"
                persistent
                v-if="loaderType==='dialog'"
                width="300"
            >
                <v-card
                    color="primary"
                    dark
                >
                    <v-card-text>
                        Please stand by
                        <v-progress-linear
                            indeterminate
                            color="white"
                            class="mb-0"
                        ></v-progress-linear>
                    </v-card-text>
                </v-card>
            </v-dialog>
        </slot>
        <slot name="error" v-bind:error="error.graphQLErrors.filter(e=>hasKey(errorMessages, e.extensions.category))"
              v-if="!$scopedSlots.props&&error!=null&&error.graphQLErrors.find(e=>hasKey(errorMessages, e.extensions.category))!=null"></slot>
        <v-dialog
            v-if="error!=null&&(onlyValidationErrors||errorMessages||error.graphQLErrors.filter(e=>hasKey(errorMessages, e.extensions.category)).length<error.graphQLErrors.length)"
            hide-overlay
            value="true"
            max-width="400"
        >
            <v-card
                min-height="200"
                width="400"

            >
                <v-layout class="pt-6" justify-center column align-center>
                    <v-icon size="100">sentiment_very_dissatisfied</v-icon>

                    <v-card-title class="text-break" v-if="onlyValidationErrors">{{
                            error.graphQLErrors.filter(e => ['validation','auth:5'].includes(e.extensions.category)).flatMap(e => Object.values(e.extensions.errors).flatMap(e=>e)).reduce((acc,x)=>acc+"\n"+x)
                        }}
                    </v-card-title>
                    <v-card-title class="text-break" v-else-if="errorMessages">{{
                            error.graphQLErrors.filter(e => hasKey(errorMessages, e.extensions.category)).map(e => errorMessages[e.extensions.category]||e.extensions.errors.join("\n")).join("\n")
                        }}
                    </v-card-title>
                    <v-card-title v-else>Oops something went wrong!</v-card-title>
                </v-layout>
            </v-card>
        </v-dialog>
        <slot name="mutate" v-bind:mutate="mMutate(mutate)" :error="error" v-if="!$scopedSlots.props"></slot>
        <slot name="props" :mutate="mMutate(mutate)" :error="error" :loading="loading"></slot>
    </ApolloMutation>
</template>

<script>

export default {
    props: {
        optimisticResponse: {
            type: Object,
        },
        mutation: {
            type: Object,
            required: true
        },
        loaderType: {
            type: String,
        },
        onlyValidationErrors: {
            type: Boolean,
            default: false
        },
        errorMessages: {
            type: Object,
        },
        variables: {
            type: Object,
        },
        guarded: {
            type: Boolean,
            default: false
        },
        update: {
            type: Function
        },
    },
    data: () => ({
        callbackId: null,
        dialog:false
    }),
    methods: {
        hasKey(v,k){
          return v==null?false:Object.keys(v).includes(k)
        },
        mMutate(mutate) {
            return (data) => {
                if (this.guarded && !this.$repositories.auth.logged) {
                    this.pushQuery({sign_in: "1"})
                    this.callbackId = this.$managers.em.attach("logged_in", _ => mutate(data))
                } else mutate(data)
            }
        }
    },
    watch: {
        "$route.query.sign_in"(v) {
            v !== "1" && this.callbackId != null && this.$managers.em.detach("logged_in", this.callbackId)
        }
    }
}
</script>
