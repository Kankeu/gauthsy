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
            <v-btn @click="()=>{
                if(refetch!=null)refetch()
            }" :loading="loading" large class="mr-3" color="accent" outlined depressed>
                <v-icon>autorenew</v-icon>
                Refresh
            </v-btn>
        </v-app-bar>
        <v-sheet height="100"></v-sheet>
        <v-layout class="px-6 px-sm-0">
            <v-flex md1 lg2 sm1></v-flex>
            <v-flex md10 lg8 sm10>
                <v-card-title class="headline pl-0">Identities Documents</v-card-title>
                <m-apollo-query no-data="documents.data" :first="20" fetchMore
                                :query="require('@graphql/document').DASHBOARD_DOCUMENTS">
                    <template v-slot:props="{data, loading, refetch}">
                        <v-row :setRefetch="setRefetch(refetch,loading)" v-if="loading" wrap>
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
                        <v-row :setRefetch="setRefetch(refetch,loading)" v-else wrap>
                            <v-col
                                v-for="document in data.documents.data" :key="document.id"
                                cols="12"
                                sm="6"
                                md="4"
                                lg="4"
                            >
                                <DocumentCard is-admin :document="document"></DocumentCard>
                            </v-col>
                        </v-row>
                    </template>
                    <template v-slot:no-data="{refetch}">
                        <slot name="header" v-bind:refetch="refetch"></slot>
                        <NoDataMBody :setRefetch="setRefetch(refetch,false)" title='No documents found'
                                     subtitle="When someone scan a document, you can see it here"
                                     :refetch="refetch"></NoDataMBody>
                    </template>
                </m-apollo-query>
            </v-flex>
            <v-flex md1 lg2 sm1></v-flex>

        </v-layout>
        /
    </v-layout>
</template>

<script>

import NoDataMBody from "../home/NoDataMBody";
import DocumentCard from "../../components/document/DocumentCard";
export default {
    components: {DocumentCard, NoDataMBody},
    data:()=>({
        refetch:null,
        loading:true,
    }),
    methods:{
        setRefetch(refetch,loading){
            this.refetch=refetch
            this.loading=loading;
        },
    }
}
</script>

