<template>
    <v-layout column>
        <v-app-bar
            fixed
            color="white"
            elevate-on-scroll
        >
            <v-toolbar-title class="headline font-weight-bold">

                <v-btn @click="$router.back()" icon>
                    <v-icon>arrow_back</v-icon>
                </v-btn>&nbsp;{{ $config.appName }}
            </v-toolbar-title>

            <v-spacer></v-spacer>

            <v-btn large class="mr-3" v-if="$repositories.auth.user.is_admin" :to="{name:'dashboard'}" color="accent"
                   depressed>
                <v-icon>dashboard</v-icon>
                Dashboard
            </v-btn>
            <v-btn large class="mr-3" @click="pushQuery({edit_profile:'1'})" color="accent" depressed>
                <v-icon>edit</v-icon>
                Profile
            </v-btn>
            <MApolloMutation guarded
                             v-slot:props="{mutate, loading}" :mutation="require('@graphql/auth').LOGOUT">
                <v-btn @click="save(mutate)" large :loading="loading" color="primary" depressed>
                    Logout
                </v-btn>
            </MApolloMutation>
        </v-app-bar>
        <v-sheet height="100"></v-sheet>
        <v-layout class="px-6 px-sm-0">
            <v-flex md1 lg2 sm1></v-flex>
            <v-flex md10 lg8 sm10>
                <v-alert class="mt-3" type="info" outlined v-if="hasRetrieve">
                    <v-layout column>
                        <div>
                            <v-btn link text small target="_blank" :href="origin">{{ origin }}</v-btn>
                            needs
                            <div :key="'p-'+j"
                                 v-for="(q,j) in queries">
                                {{ j !== 0 ? 'and' : '' }} one document between {
                                <template v-for="(query,i) in q">
                                    <v-chip
                                        class="ma-2"
                                        color="primary"
                                        :outlined="!query.selected"
                                        :key="i"
                                    >
                                        <v-avatar v-if="query.selected" left>
                                            <v-icon>check</v-icon>
                                        </v-avatar>
                                        {{ query.type + " of " + query.country }}
                                    </v-chip>
                                    {{ i != q.length - 1 ? ',' : '' }}
                                </template>
                                }

                            </div>
                        </div>
                        <v-layout>
                            <v-spacer></v-spacer>
                            <v-btn color="error" @click="close"
                                   style="border-bottom-right-radius: 0;border-top-right-radius: 0" depressed>Cancel
                            </v-btn>
                            <MApolloMutation :error-messages="{'constraint:4':null,'constraint:5': null}"
                                             v-slot:props="{mutate,loading}"
                                             :mutation="require('@graphql/document').GENERATE_TOKEN_TO_DOCUMENTS">
                                <v-btn color="accent" @click="getToken(mutate)"
                                       style="border-bottom-left-radius: 0;border-top-left-radius: 0" depressed>Confirm
                                </v-btn>
                            </MApolloMutation>
                        </v-layout>
                    </v-layout>
                </v-alert>
                <v-card-title class="headline pl-0">Identities Documents</v-card-title>
                <m-apollo-query no-data="me.documents.data" :first="10" fetchMore
                                :query="require('@graphql/document').DOCUMENTS">
                    <template v-slot:props="{data, loading, refetch}">
                        <v-row v-if="loading" wrap>
                            <v-col
                                v-for="i in 6" :key="i"
                                cols="12"
                                sm="6"
                                md="4"
                                lg="4"
                            >
                                <DocumentCard loading></DocumentCard>
                            </v-col>
                        </v-row>
                        <v-row v-else wrap>
                            <v-col
                                v-for="document in data.me.documents.data" :key="document.id"
                                cols="12"
                                sm="6"
                                md="4"
                                lg="4"
                            >
                                <DocumentCard
                                    :disabled="hasRetrieve&&!queries.flatMap(e=>e.map(e2=>e2.key)).includes(document.issued_by+':'+document.type)"
                                    @change="v=>select(v,document)" :hasRetrieve="hasRetrieve" @deleted="_=>refetch()"
                                    :document="document"></DocumentCard>
                            </v-col>
                        </v-row>
                    </template>
                    <template v-slot:no-data="{refetch}">
                        <slot name="header" v-bind:refetch="refetch"></slot>
                        <NoDataMBody title='No documents found'
                                     subtitle="When you scan a document, you can see it here"
                                     :refetch="refetch"></NoDataMBody>
                    </template>
                </m-apollo-query>
                <v-divider class="mt-6"></v-divider>
                <v-card-title class="headline pl-0">Scan Identities Documents</v-card-title>
                <v-row wrap>
                    <v-col
                        v-for="type in documentTypes" :key="type"
                        cols="12"
                        sm="6"
                        md="4"
                        lg="4"
                    >
                        <v-card hover :to="{name:'boarding', query:{type}}" class="pa-2" height="210">
                            <v-layout fill-height>
                                <v-flex md8>
                                    <v-layout column fill-height justify-space-between align-start>
                                        <div class="headline">{{
                                                type === "ID" ? 'Identity Card' : 'Residence Permit'
                                            }}
                                        </div>
                                        <div>
                                            <v-img width="100" height="100"
                                                   src="/images/defaults/face_icon.png"></v-img>
                                        </div>
                                    </v-layout>
                                </v-flex>
                                <v-flex md4>
                                    <v-layout column fill-height justify-end align-end>
                                        <v-btn color="primary" depressed>Let's start
                                            <v-icon>navigate_next</v-icon>
                                        </v-btn>
                                    </v-layout>
                                </v-flex>
                            </v-layout>
                        </v-card>
                    </v-col>
                </v-row>
            </v-flex>
            <v-flex md1 lg2 sm1></v-flex>
        </v-layout>
    </v-layout>
</template>

<script>


import DocumentCard from "../../components/document/DocumentCard";
import NoDataMBody from "./NoDataMBody";

export default {
    components: {NoDataMBody, DocumentCard},
    data: () => ({
        selectedDocuments: {}
    }),
    computed: {
        documentTypes() {
            return ["ID", "AR"]
        },
        hasRetrieve() {
            return this.$route.query.retrieve != null && this.$route.query.retrieve.length > 0
        },
        queries() {
            let bigParts = this.$route.query.retrieve.split("]").filter(e => e.length > 0).map(e => e.replace(",[", "").replace("[", "").split(","))

            return bigParts.map(parts => parts.map(part => {
                let smParts = part.split(":");
                return {
                    selected: this.selectedDocuments[part] != null,
                    key: part,
                    country: {"CM": "Cameroon", "DE": "Germany", "RW": "Rwanda"}[smParts[0]],
                    type: {"AR": "Residence permit", "ID": "Identity card"}[smParts[1]]
                }
            }))
        },
        origin() {
            return this.$route.query.redirect
        }
    },
    methods: {
        save(mutate) {
            mutate({
                update: (store, {data}) => {
                    console.log(data)
                    if (data.logout)
                        this.$repositories.auth.logout()
                }
            })
        },
        select(v, document) {
            let key = document.issued_by + ":" + document.type;
            if (!v) this.$delete(this.selectedDocuments, key)
            else {
                let q = this.queries.find(q => q.map(e => e.key).includes(key))
                q.forEach(e => this.$delete(this.selectedDocuments, e.key))
                this.$set(this.selectedDocuments, key, document.id)
            }
        },
        close() {
            window.opener.returnValue = null
            window.close()
        },
        getToken(mutate) {
            if (!this.queries.every(q => !q.every(e => this.selectedDocuments[e.key] == null)))
                return this.$snackbar.show({text: 'Select all the required documents', color: 'error'})

            let form = {
                host: this.origin,
                documents: Object.keys(this.selectedDocuments).map(e => ({id: this.selectedDocuments[e]}))
            }
            console.log(form)
            mutate({
                variables: {data: form},
                update: (store, {data}) => {
                    if (opt(data).generateTokenToDocuments) {
                        this.$snackbar.show({
                            text: "Token sent",
                            color: 'success',
                        })
                        window.opener.postMessage(data.generateTokenToDocuments, this.origin)
                        window.close()
                    }
                }
            })

        }
    },
}
</script>
