<template>
    <v-dialog persistent :value="value" @input="v=>$emit('input',v)" max-width="500">
        <v-card light class="align-self-center">
            <v-card-title>
                {{ document.type === 'ID' ? 'Identity Card' : 'Residence Permit' }}
                <v-spacer></v-spacer>
                <v-btn icon @click="$emit('close')">
                    <v-icon>close</v-icon>
                </v-btn>
            </v-card-title>
            <v-container class="pa-6">
                <v-layout align-baseline class="mb-3" v-if="isAdmin">
                    <v-flex md6>
                        <v-dialog
                            v-model="dialog"
                            width="500"
                        >
                            <template v-slot:activator="{ on, attrs }">
                                <v-btn v-bind="attrs"
                                       v-on="on" color="error"
                                       style="border-bottom-right-radius: 0;border-top-right-radius: 0" block depressed>
                                    Reject
                                </v-btn>
                            </template>
                            <v-card>
                                <v-card-title>Do you want to reject this document?
                                    <v-spacer></v-spacer>
                                </v-card-title>
                                <v-card-text>
                                    <v-form ref="form">
                                        <v-select label="For which reason do you want to reject this document?"
                                                  :rules="$validations.make('required','filled')" v-model="form.item"
                                                  :items="items"></v-select>
                                        <v-textarea v-model.trim="form.message" v-if="form.item==='Other'"
                                                    maxlength="640"
                                                    :rules="$validations.make('required','filled','maxLength(320)')"
                                                    label="Reason"></v-textarea>
                                    </v-form>
                                </v-card-text>
                                <v-card-actions class="align-baseline">
                                    <v-spacer></v-spacer>
                                    <v-btn @click="dialog=false" class="mr-3" depressed>Cancel</v-btn>
                                    <MApolloMutation
                                        :error-messages="{'constraint:2':'This document has been already verified'}"
                                        class="mt-3" guarded
                                        v-slot:props="{mutate, error, loading}"
                                        :mutation="require('@graphql/document').REJECT">
                                        <v-btn color="primary" :loading="loading" @click="reject(mutate)" depressed>
                                            Reject
                                        </v-btn>
                                    </MApolloMutation>
                                </v-card-actions>
                            </v-card>
                        </v-dialog>
                    </v-flex>
                    <v-flex md6>
                        <MApolloMutation class="mt-3" guarded
                                         :error-messages="{'constraint:3':'This document has been already verified'}"
                                         v-slot:props="{mutate, error, loading}"
                                         :mutation="require('@graphql/document').VALIDATE">
                            <MBtnConfirm block confirm-hint-text="Do you really want to validate this document?"
                                         confirm-title="Validate document" color="primary" depressed
                                         @click="validate(mutate)"
                                         :loading="loading"
                                         style-btn="border-bottom-left-radius: 0;border-top-left-radius: 0">Validate
                            </MBtnConfirm>
                        </MApolloMutation>
                    </v-flex>
                </v-layout>
                <v-alert
                    v-else
                    outlined
                    :type="document.valid?'success':(document.verified_at==null?'info':'error')"
                    prominent
                >
                    <span v-if="document.valid">This document is valid</span>
                    <span v-else-if="document.verified_at == null">Waiting for verification</span>
                    <div v-else>This document is invalid. <br/>Reason: "{{ document.message }}"</div>
                </v-alert>
                <div class="text-caption font-weight-medium">
                    Document type
                </div>
                <div class="font-weight-bold text--h6">
                    {{ document.payload.document_type }}
                </div>
                <v-divider class="my-3"></v-divider>
                <div class="text-caption font-weight-medium">
                    Surname
                </div>
                <div class="font-weight-bold text--h6">
                    {{ document.payload.surname }}
                </div>
                <v-divider class="my-3"></v-divider>
                <div class="text-caption font-weight-medium">
                    Forename
                </div>
                <div class="font-weight-bold text--h6">
                    {{ document.payload.forename }}
                </div>
                <v-divider class="my-3"></v-divider>
                <div class="text-caption font-weight-medium">
                    Birth date
                </div>
                <div class="font-weight-bold text--h6">
                    {{ document.payload.birth_date }}
                </div>
                <v-divider class="my-3"></v-divider>
                <div class="text-caption font-weight-medium">
                    Expiry date
                </div>
                <div class="font-weight-bold text--h6">
                    {{ document.payload.expiry_date }}
                </div>
                <v-divider class="my-3"></v-divider>
                <div class="text-caption font-weight-medium">
                    Document number
                </div>
                <div class="font-weight-bold text--h6">
                    {{ document.payload.document_number }}
                </div>
                <v-divider class="my-3"></v-divider>
                <div class="text-caption font-weight-medium">
                    Sex
                </div>
                <div class="font-weight-bold text--h6">
                    {{ document.payload.sex }}
                </div>
                <v-divider class="my-3"></v-divider>
                <div class="text-caption font-weight-medium">
                    Nationality country code
                </div>
                <div class="font-weight-bold text--h6">
                    {{ document.payload.nationality_country_code }}
                </div>
                <v-divider class="my-3"></v-divider>
                <div class="text-caption font-weight-medium">
                    Personal number
                </div>
                <div class="font-weight-bold text--h6">
                    {{ document.payload.personal_number }}
                </div>
                <v-divider class="my-3"></v-divider>
                <div class="text-caption font-weight-medium">
                    Personal number 2
                </div>
                <div class="font-weight-bold text--h6">
                    {{ document.payload.personal_number2 }}
                </div>
                <MImage class="my-3" width="100%" height="210" :src="front.path"></MImage>
                <MImage class="mb-3" :src="back.path" width="100%" height="210"></MImage>
                <MImage :src="face.path" width="100%" height="400"></MImage>
                <MApolloMutation class="mt-3" v-if="!isAdmin" guarded
                                 v-slot:props="{mutate, error, loading}"
                                 :mutation="require('@graphql/document').DELETE">
                    <MBtnConfirm block @click="remove(mutate)" :loading="loading"
                                 confirm-title="Delete this document"
                                 confirm-hint-text="Do you really want to delete that?" class-names="mb-2" color="error"
                                 depressed>Delete
                    </MBtnConfirm>
                </MApolloMutation>
            </v-container>
        </v-card>
    </v-dialog>
</template>

<script>
import MImage from "../image/MImage";
import MBtnConfirm from "../buttons/MBtnConfirm";

export default {
    components: {MBtnConfirm, MImage},
    props: {
        value: {type: Boolean, default: false},
        isAdmin: {type: Boolean, default: false},
        document: {type: Object, required: true},
    },
    data: () => ({
        dialog: false,
        form: {
            item: null,
            reason: null,
        },
        validateDialog: false,
    }),
    computed: {
        items() {
            return ['Other', "The scanned information does not match the information in the document", "This document seems to be invalid", "The document has expired", "The document images are not clear enough", "The face photo is not clear enough", "The face on the document does not match the scanned face"]
        },
        front() {
            return this.document.images.data.find(e => e.type === "FRONT");
        },
        back() {
            return this.document.images.data.find(e => e.type === "BACK");
        },
        face() {
            return this.document.images.data.find(e => e.type === "FACE");
        }
    },
    methods: {
        reject(mutate) {
            if (!this.$refs.form.validate())
                return this.$snackbar.show({text: 'Invalid form', color: 'error'})

            let form = {id: this.document.id, reason: this.form.item !== 'Other' ? this.form.item : this.form.reason};
            console.log(form)
            mutate({
                variables: {data: form},
                update: (store, {data}) => {
                    console.log(data)
                    if (opt(data).rejectDocument) {
                        this.$snackbar.show({
                            text: "Document rejected",
                            color: 'success',
                        })
                        this.removeFromCache(store)
                        this.$emit('close')
                    }
                }
            })
        },
        validate(mutate) {
            let form = {id: this.document.id};
            console.log(form)
            mutate({
                variables: {data: form},
                update: (store, {data}) => {
                    console.log(data)
                    if (opt(data).validateDocument) {
                        this.$snackbar.show({
                            text: "Document validated",
                            color: 'success',
                        })
                        this.removeFromCache(store)
                        this.$emit('close')
                    }
                }
            })
        },
        removeFromCache(store) {
            let index = -1
            let query;
            let data;
            let page = 1
            while (index < 0) {
                try {
                    query = {
                        query: require('@graphql/document').DASHBOARD_DOCUMENTS,
                        variables: {
                            first: 20,
                            page
                        },
                    }
                    // Read the query from cache
                    data = store.readQuery(query)
                    // Mutate cache result
                    index = data.documents.data.findIndex(e => e.id === this.document.id)
                    if(index>-1){
                        data.documents.data.splice(index, 1)
                        // Write back to the cache
                        store.writeQuery({
                            ...query,
                            data,
                        })
                    }
                } catch (e) {
                    break;
                }
            }
            page++
        },
        remove(mutate) {
            mutate({
                variables: {
                    data: {id: this.document.id}
                },
                update: (store, {data: {deleteDocument}}) => {
                    if (!deleteDocument) return;
                    this.$emit('close')
                    this.$emit('deleted')
                    this.$snackbar.show({text: 'Document deleted', color: 'success'})
                }
            })
        },
    },
}
</script>
