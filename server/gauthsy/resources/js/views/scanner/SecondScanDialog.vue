<template>
    <v-dialog persistent overlay-opacity=".5" :value="value" @input="v=>$emit('input',v)" max-width="500">
        <v-card light class="align-self-center">
            <v-card-title>
                {{ document.type === 'ID' ? 'Identity Card' : 'Residence Permit' }}
                <v-spacer></v-spacer>
            </v-card-title>
            <v-container class="pa-6">
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
                <v-img class="my-3" :src="back.file" contains width="100%" height="200"></v-img>
            </v-container>
            <v-card-actions class="layout">
                <v-spacer></v-spacer>
                <v-btn text color="primary" @click="$emit('rescan')">Rescan</v-btn>
                <v-btn text color="accent" @click="$emit('confirm')">Confirm</v-btn>
            </v-card-actions>
        </v-card>
    </v-dialog>
</template>

<script>

export default {
    props: {
        value: {type: Boolean, default: false},
        document: {type: Object, required: true},
    },
    data: () => ({
        dialog: false,
    }),
    computed: {
        back() {
            return this.document.images.find(e => e.type === "BACK");
        },
    },
    methods: {

    },
}
</script>
