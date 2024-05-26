<template>
    <v-lazy
        :options="{
          threshold: .5
        }"
        transition="fade-transition slide-y-reverse-transition"
    >
        <v-hover v-slot="{ hover }">
            <div>
                <DocumentCardSkeleton v-if="loading"></DocumentCardSkeleton>
                <v-tooltip :color="document.valid?'success':'error'" v-else top>
                    <template v-slot:activator="{attrs,on}">
                        <v-card :disabled="disabled" v-bind="attrs" v-on="on"
                                :color="(!active?null:'#1c31444d')" outlined raised hover @click="dialog=!dialog"
                                :elevation=" hover ? 12 : 1" class="pa-2" height="210">
                            <v-layout fill-height>
                                <v-flex md4>
                                    <v-layout column fill-height justify-space-between align-start>
                                        <div class="headline font-weight-bold">{{
                                                document.issued_by.toUpperCase()
                                            }}
                                        </div>
                                        <div>
                                            <MImage :src="face.path"></MImage>
                                        </div>
                                    </v-layout>
                                </v-flex>
                                <v-flex md8>
                                    <v-layout column fill-height justify-space-between align-end>
                                        <v-flex style="width: 100%" align-self-start>
                                            <v-layout column>
                                                <v-layout>
                                                    <div class="font-weight-bold">
                                                        {{
                                                            document.type === 'ID' ? 'Identity Card' : 'Residence Permit'
                                                        }}
                                                    </div>
                                                    <v-spacer></v-spacer>
                                                    <div class="font-weight-bold">
                                                        {{ document.payload.document_number }}
                                                    </div>
                                                </v-layout>
                                                <div class="text-caption font-weight-medium">
                                                    Surname
                                                </div>
                                                <div class="font-weight-bold text--h6">
                                                    {{ document.payload.surname }}
                                                </div>
                                                <div class="text-caption font-weight-medium">
                                                    Forename
                                                </div>
                                                <div class="font-weight-bold text--h6">
                                                    {{ document.payload.forename }}
                                                </div>
                                                <div class="text-caption font-weight-medium">
                                                    Birth date
                                                </div>
                                                <div class="font-weight-bold text--h6">
                                                    {{ document.payload.birth_date }}
                                                </div>
                                            </v-layout>
                                        </v-flex>
                                        <v-btn color="primary" depressed>See more
                                            <v-icon>navigate_next</v-icon>
                                        </v-btn>
                                    </v-layout>
                                </v-flex>
                            </v-layout>
                            <DocumentDetailsDialog :isAdmin="isAdmin" @deleted="_=>$emit('deleted')"
                                                   :document="document"
                                                   :value="dialog" @close="v=>dialog=v"></DocumentDetailsDialog>

                            <v-checkbox v-if="hasRetrieve" @click.stop :disabled="!document.valid" @change="select" background-color="white"
                                        style="position: absolute;top: -10px;right: 0"></v-checkbox>
                        </v-card>
                    </template>
                    <span v-if="document.valid">This document has been validated</span>
                    <span v-else>This document has not been validated</span>
                </v-tooltip>
            </div>
        </v-hover>
    </v-lazy>
</template>

<script>
import DocumentCardSkeleton from "./DocumentCardSkeleton";
import MImage from "../image/MImage";
import DocumentDetailsDialog from "./DocumentDetailsDialog";

export default {
    components: {DocumentDetailsDialog, MImage, DocumentCardSkeleton},
    props: {
        isAdmin: {type: Boolean, default: false},
        loading: {type: Boolean, default: false},
        disabled: {type: Boolean, default: false},
        hasRetrieve: {type: Boolean, default: false},
        document: {type: Object}
    },
    data: () => ({
        dialog: false,
        active: false
    }),
    computed: {
        face() {
            return this.document.images.data.find(e => e.type === "FRONT_FACE");
        },
    },
    methods: {
        select(v) {
            this.active = v
            this.$emit("change", v)
        }
    }
}
</script>
