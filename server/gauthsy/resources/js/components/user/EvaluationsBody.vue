<template>
    <v-card flat>
        <v-layout class="blue-grey darken-4 white--text" column>
            <v-card-title>General evaluation
                <v-spacer></v-spacer>
                <v-btn
                    outlined
                    color="accent"
                    dark
                    class="ml-3"
                    depressed
                    v-if="refetch"
                    @click="refetch"
                >
                    <v-icon>refresh</v-icon>
                </v-btn>
            </v-card-title>
            <v-layout align-center class="mx-5 mb-5">
                <div class="headline mr-3">{{ user.rating }}</div>
                <v-divider class="grey" vertical></v-divider>
                <v-layout column>
                    <v-rating readonly half-increments background-color="secondary" half-icon="star_half"
                              :value="user.rating"></v-rating>
                    <div class="ml-2">out of {{ user.evaluations_count }} evaluations</div>
                </v-layout>
            </v-layout>
        </v-layout>
        <m-apollo-query no-data="user.evaluations.data" :first="10" :variables="{id: user.id}"
                        fetchMore
                        :query="require('@graphql/evaluation').USER_EVALUATIONS">
            <template v-slot:props="{data, loading, refetch}">
                <v-list outlined v-if="loading">
                    <v-list-item v-for="i in 10" :key="i">
                        <v-list-item-content>
                            <v-list-item-title>
                                <v-skeleton-loader type="text"></v-skeleton-loader>
                            </v-list-item-title>
                            <v-list-item-subtitle>
                                <v-skeleton-loader type="text"></v-skeleton-loader>
                            </v-list-item-subtitle>
                        </v-list-item-content>
                        <v-list-item-action>
                            <v-skeleton-loader width="100" type="text"></v-skeleton-loader>
                        </v-list-item-action>
                    </v-list-item>
                </v-list>
                <v-list outlined :func="setRefetch(refetch)" v-else>
                    <v-list-item v-for="evaluation in data.user.evaluations.data" :key="evaluation.id">
                        <v-list-item-content>
                            <v-list-item-title>
                                Anonymous
                            </v-list-item-title>
                            <v-list-item-subtitle style="white-space: initial">
                                {{ evaluation.comment }}
                            </v-list-item-subtitle>
                        </v-list-item-content>
                        <v-list-item-action>
                            <v-rating small dense half-increments background-color="secondary" half-icon="star_half"
                                      :value="evaluation.note"></v-rating>
                            <m-time-ago :datetime="evaluation.created_at"></m-time-ago>
                        </v-list-item-action>
                    </v-list-item>
                </v-list>
            </template>
            <template v-slot:no-data="{refetch}">
                <NoDataMBody title='No evaluations found'
                             subtitle="When someone evaluates this user, you can see it here"
                             :refetch="refetch"></NoDataMBody>
            </template>
        </m-apollo-query>
    </v-card>
</template>

<script>

import MTimeAgo from "@components/time/MTimeAgo";
import NoDataMBody from "../../views/home/NoDataMBody";

export default {
    components: {NoDataMBody, MTimeAgo},
    props: {
        user: {type: Object, required: true},
    },
    data: () => ({
        refetch: null
    }),
    methods: {
        setRefetch(refetch) {
            this.refetch = refetch
        }
    }
}
</script>
