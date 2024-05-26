<template>
    <v-layout column>
        <MCamera @scan="scan"/>
        <MApolloMutation
            loader-type="dialog"
            style="width: 100%" guarded
            only-validation-errors
            v-slot:mutate="{mutate, error}"
            :mutation="require('@graphql/document').CREATE">
            <v-dialog
                :setMutate="setMutate(mutate)"
                v-model="dialog"
                overlay-opacity=".5"
                persistent
                width="300"
            >
                <v-card>
                    <v-card-title>Sending failed</v-card-title>
                    <v-card-actions class="layout column">
                        <v-btn color="accent" block depressed
                               @click="send(mutate)"
                               :loading="loading">Retry
                        </v-btn>
                        <v-btn depressed @click="$router.back()" class="mt-3" block color="primary">Cancel</v-btn>
                    </v-card-actions>
                </v-card>
            </v-dialog>
        </MApolloMutation>

    </v-layout>
</template>

<script>
import MCamera from "./MCamera";

export default {
    components: {MCamera},
    data: () => ({
        form: null,
        mutate: null,
        dialog: false,
    }),
    methods: {
        setMutate(mutate) {
            this.mutate = mutate
        },
        scan(form) {
            console.log(form)
            this.form = form
            this.send(this.mutate)
        },
        send(mutate) {
            let form = {
                ...this.form,
                images: this.form.images.map(e => ({
                    ...e,
                    file: this.blobToFile(e.file, e.type.toLowerCase() + (e.type==="FRONT_FACE"?".png":".jpeg"))
                }))
            };
            this.dialog = false
            console.log(form)
            mutate({
                variables: {data: form},
                update: (store, {data}) => {
                    console.log(data)
                    if (opt(data).createDocument) {
                        this.$snackbar.show({
                            text: "Document sent",
                            color: 'success',
                        })
                        this.$router.push({name: 'submitted'})
                    } else this.dialog = true
                }
            })
        },
        blobToFile(dataURI, fileName) {
            let theBlob = this.dataURItoBlob(dataURI)
            theBlob.lastModifiedDate = new Date();
            theBlob.name = fileName;
            return theBlob;
        },
        dataURItoBlob(dataURI) {
            let byteString = atob(dataURI.split(',')[1]);
            let mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0];
            let ab = new ArrayBuffer(byteString.length);
            let ia = new Uint8Array(ab);
            for (let i = 0; i < byteString.length; i++) {
                ia[i] = byteString.charCodeAt(i);
            }
            return new Blob([ab], {type: mimeString});
        }
    },
    mounted() {
        console.log(this)
    }
}
</script>

