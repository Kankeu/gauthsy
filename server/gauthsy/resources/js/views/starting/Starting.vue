<template>
    <v-layout column>
        <v-app-bar
            fixed
            color="white"
            elevate-on-scroll
        >
            <v-toolbar-title class="headline font-weight-bold">{{ $config.appName }}</v-toolbar-title>

            <v-spacer></v-spacer>

            <v-btn color="primary" large @click="navigate" depressed>
                Sign in
            </v-btn>
        </v-app-bar>
        <v-sheet height="100"></v-sheet>
        <v-layout class="px-6 px-sm-0 py-12">
            <v-flex md1 lg2 sm1></v-flex>
            <v-flex md10 lg8 sm10
                    :style="'background-image:url('+$config.images.startingBg+');background-size: contain;'">
                <v-layout wrap>
                    <v-flex md6 sm12>
                        <div class="text-sm-h3 text-md-h3 headline active">Knowing your customers has never been so easy
                            and fast.
                        </div>
                        <div class="text-sm-h6 text-md-h6 mt-12">
                            The identity verification platform. <br>Built for security. Loved by users.
                        </div>
                        <div class="mt-6">
                            <v-layout column>
                                <v-flex class="mb-3">
                                    <v-btn large color="accent" :to="{name:'home'}" depressed>Identification in browser</v-btn>
                                </v-flex>
                                <v-flex>
                                    <v-btn large color="primary" @click="pushQuery({download:'1'})" depressed>Download
                                        apk
                                    </v-btn>
                                </v-flex>
                            </v-layout>
                        </div>
                    </v-flex>
                    <v-flex md6 class="mt-sm-6 mt-md-0" sm12>
                        <v-layout column :align-end="$vuetify.breakpoint.mdAndUp"
                                  :align-center="$vuetify.breakpoint.smAndDown">
                            <v-img max-height="600" max-width="400" contain
                                   src="/images/defaults/scanning_animation.gif"></v-img>
                        </v-layout>
                    </v-flex>
                </v-layout>
            </v-flex>
            <v-flex md1 lg2 sm1></v-flex>
        </v-layout>
        <v-sheet color="#fafafa">
            <v-layout class="my-12 px-6 px-sm-0 py-12">
                <v-flex md1 lg2 sm1></v-flex>
                <v-flex md10 lg8 sm10>
                    <v-layout align-center wrap>
                        <v-flex md6 class="pr-sm-6" sm12>
                            <div class="text-sm-h4 headline font-weight-bold">Better for your business.</div>
                            <div class="text--secondary text-h6 mt-6">
                                Provide your customers a fast, friendly and secure onboarding process. Suitable
                                for desktop, tablet, mobile and point-of-sale, with {{ $config.appName }} your customers
                                can
                                enjoy a flawless and secure identity verification experience.
                            </div>
                            <div class="text-sm-h4 headline font-weight-bold mt-12">Better for your customers.
                            </div>
                            <div class=" text--secondary text-h6 mt-6">
                                Built for the needs of an enterprise, but offers easy and seamless integration
                                for businesses of any size. With {{ $config.appName }}, you can improve conversion while
                                ensuring a high level of data protection.
                            </div>
                        </v-flex>
                        <v-flex class=" hidden-xs-only mt-md-0 mt-6" md6 sm12>
                            <v-layout>
                                <v-flex>
                                    <v-img src="/images/defaults/smiling_man.jpg" height="400" width="300">

                                    </v-img>
                                </v-flex>
                                <v-layout column>
                                    <v-img src="/images/defaults/smiling_woman.jpg" height="180" width="300">

                                    </v-img>
                                    <v-img class="mt-2" src="/images/defaults/smiling_woman2.jpg" height="180"
                                           width="300">

                                    </v-img>
                                </v-layout>
                            </v-layout>
                        </v-flex>
                    </v-layout>
                </v-flex>
                <v-flex md1 lg2 sm1></v-flex>
            </v-layout>
        </v-sheet>
        <v-layout class="mt-12 px-6 px-sm-0 py-12">
            <v-flex md1 lg2 sm1></v-flex>
            <v-flex md10 lg8 sm10>
                <v-data-iterator
                    :items="items"
                    :items-per-page.sync="itemsPerPage"
                    hide-default-footer
                >
                    <template v-slot:header>
                        <v-toolbar
                            class="mb-2"
                            flat
                            color="#fafafa"
                        >
                            <v-toolbar-title class="font-weight-bold headline text-sm-h4">Supported documents
                            </v-toolbar-title>
                        </v-toolbar>
                    </template>

                    <template v-slot:default="props">
                        <v-row class="justify-space-between">
                            <v-col
                                v-for="item in props.items"
                                :key="item.name"
                                cols="12"
                                sm="6"
                                md="4"
                                lg="3"
                            >
                                <v-card color="#fafafa" flat>
                                    <v-card-title class="subheading font-weight-bold text-h5">
                                        {{ item.name }}
                                    </v-card-title>
                                    <v-divider></v-divider>
                                    <v-list color="#fafafa" dense>
                                        <v-list-item>
                                            <v-list-item-content class="subtitle-1">Identity Card:</v-list-item-content>
                                            <v-icon v-if="item.id_card" color="primary">check</v-icon>
                                            <v-icon v-else>close</v-icon>
                                        </v-list-item>
                                        <v-list-item>
                                            <v-list-item-content class="subtitle-1">Residence Permit:
                                            </v-list-item-content>
                                            <v-icon v-if="item.residence_permit" color="primary">check</v-icon>
                                            <v-icon v-else>close</v-icon>
                                        </v-list-item>
                                    </v-list>
                                </v-card>
                            </v-col>
                        </v-row>
                    </template>
                </v-data-iterator>
                <v-layout column>
                    <v-toolbar
                        class="my-2"
                        color="#fafafa"
                        flat
                    >
                        <v-toolbar-title class="font-weight-bold headline text-sm-h4">
                            How is it work?
                        </v-toolbar-title>
                    </v-toolbar>
                    <v-row class="justify-space-between mb-2">
                        <v-col
                            cols="12"
                            sm="6"
                            md="4"
                            lg="3"
                        >
                            <v-card color="#fafafa" flat>
                                <v-card-title class="subheading font-weight-bold text-h5">
                                    First Step
                                </v-card-title>

                                <v-divider></v-divider>

                                <v-card-text class="subtitle-1">
                                    Customers use the browser or our app (
                                    <v-btn small link text color="primary" @click="pushQuery({download:'1'})" depressed>
                                        Download apk
                                    </v-btn>
                                    ) to scan their identity document and wait until the scanned
                                    document is confirmed by one of our agents.
                                </v-card-text>
                            </v-card>
                        </v-col>
                        <v-col
                            cols="12"
                            sm="6"
                            md="4"
                            lg="3"
                        >
                            <v-card color="#fafafa" flat>
                                <v-card-title class="subheading font-weight-bold text-h5">
                                    Second Step
                                </v-card-title>

                                <v-divider></v-divider>

                                <v-card-text class="subtitle-1">
                                    Your company can access the scanned document data by calling url: <strong>http://localhost:
                                    8000/api/provider/?retrieve=[&lt;country&gt;:&lt;document type&gt;[,&lt;country&gt;:&lt;document
                                    type&gt;]*]*&redirect=&lt;origin&gt;</strong>
                                    <br>
                                    <strong>&lt;country&gt;</strong> = "CM" | "DE" | "RW"
                                    <br>
                                    <strong>&lt;document type&gt;</strong> = "AR" | "ID"
                                    <br>
                                    e.g.: <strong>retrieve=[CM:ID,DE:ID],[RW:ID]</strong> means, I need an identity card
                                    of Cameroon or Germany and an identity card of rwanda
                                </v-card-text>
                            </v-card>
                        </v-col>
                        <v-col
                            cols="12"
                            sm="6"
                            md="4"
                            lg="3"
                        >
                            <v-card color="#fafafa" flat>
                                <v-card-title class="subheading font-weight-bold text-h5">
                                    Third Step
                                </v-card-title>

                                <v-divider></v-divider>

                                <v-card-text class="subtitle-1">
                                    The called window reviews a token which will can be only used by the current host to
                                    retrieve the data by GraphQL.
                                    Use the token to retrieve data from our GraphQL API by calling the query <strong>documents(token:
                                    Token)</strong> at the url <strong>http://localhost:8000/graphql</strong>.
                                </v-card-text>
                            </v-card>
                        </v-col>
                    </v-row>
                    <v-card-title class="headline pl-0 font-weight-bold">Ask the user for identity(ies) document(s) and get the token back</v-card-title>
                    <code-highlight language="javascript" class="m-code">
                        &lt;script&gt;
                        // set event listener for getting token back
                        window.addEventListener("message",onMessage);
                        // open a new window and retrieve an identity card of Cameroon or a residence permit of Germany
                        window.open(
                        "{{ $config.appUrl }}/api/provider/?retrieve=[CM:ID,DE:AR]&redirect=https://domain.com",
                        "_blank", "height=900,width=900");
                        &lt;/script&gt;
                    </code-highlight>
                    <v-card-title class="headline pl-0 font-weight-bold">Use the token to fetch the documents with attached images from GraphQL API</v-card-title>
                    <code-highlight language="javascript" class="m-code">
                        &lt;script&gt;
                        const DOCUMENTS_QUERY =  `
                            query($data: TokenInput){
                                documents(first:10, page: 1, data: $data){
                                    paginatorInfo{hasMorePages}
                                    data{
                                        id
                                        type
                                        number
                                        issued_by
                                        valid
                                        verified_at
                                        created_at
                                        updated_at
                                        payload{
                                        surname
                                        forename
                                        country_code
                                        document_type
                                        document_number
                                        nationality_country_code
                                        sex
                                        birth_date
                                        expiry_date
                                        personal_number
                                        personal_number2
                                        }
                                        images(first:10,page:1){
                                            data{
                                                type
                                                full_path
                                            }
                                        }
                                    }
                                }
                            }
                        `
                        async function onMessage(event){
                            console.log(event.data)
                            // fetch the identity(ies) document(s)
                            let res = await fetch('https://gauthsy.restopres.com/graphql', {
                                method: 'POST',
                                headers: {
                                'Accept': 'application/json',
                                'Content-Type': 'application/json'
                                },
                                body: JSON.stringify({
                                    query: DOCUMENTS_QUERY,
                                    variables: {data: {token: event.data}}
                                })
                            });
                            let resParsed = await res.json()
                            console.log(resParsed)
                            // fetch the images of each document
                            resParsed.data.documents.data.forEach(document => {
                                document.images.data.forEach(async image => {
                                // fetch the image by passing the token as query in the URL
                                let res = await fetch(image.full_path + "?token=" + event.data)
                                let resParsed = await res.blob()
                                })
                            })
                        }

                        &lt;/script&gt;
                    </code-highlight>
                    <v-btn outlined block target="_blank" link href="/graphql-playground" color="primary" large
                           depressed>Go to Api
                        <v-icon>navigate_next</v-icon>
                    </v-btn>
                </v-layout>
            </v-flex>
            <v-flex md1 lg2 sm1></v-flex>
        </v-layout>
    </v-layout>
</template>
<script>


import SignInDialog from "../../components/sign_in/SignInDialog";
import CodeHighlight from "vue-code-highlight/src/CodeHighlight.vue";
import "vue-code-highlight/themes/duotone-sea.css";
import "vue-code-highlight/themes/window.css";

export default {
    components: {SignInDialog, CodeHighlight},
    data: () => ({
        itemsPerPage: 4,
        items: [
            {
                name: 'Cameroon',
                id_card: true,
                residence_permit: false,
            },
            {
                name: 'Germany',
                id_card: true,
                residence_permit: true,
            },
            {
                name: 'Rwanda',
                id_card: true,
                residence_permit: false,
            }
        ]
    }),
    methods: {
        navigate() {
            if (this.$repositories.auth.logged)
                this.$router.push({name: 'home'})
            else this.pushQuery({sign_in: '1'})
        },
    }
}
</script>
<style>
.m-code > pre {
    width: 100% !important;
}
</style>

