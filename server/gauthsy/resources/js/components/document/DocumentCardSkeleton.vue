<template>
    <v-card hover elevation="1" class="pa-2" height="210" v-else>
        <v-layout fill-height>
            <v-flex md4>
                <v-layout column fill-height justify-space-between align-start>
                    <div class="headline font-weight-bold">
                        <v-skeleton-loader width="50" type="text"></v-skeleton-loader>
                    </div>
                    <div>
                        <v-skeleton-loader type="image"  style="border-top-left-radius: 4px;border-bottom-left-radius: 4px;" width="100" height="100"></v-skeleton-loader>
                    </div>
                </v-layout>
            </v-flex>
            <v-flex md8>
                <v-layout column fill-height justify-space-between align-end>
                    <v-flex style="width: 100%" align-self-start>
                        <v-layout column>
                            <v-layout>
                                <div class="font-weight-bold">
                                    <v-skeleton-loader width="100" type="text"></v-skeleton-loader>
                                </div>
                                <v-spacer></v-spacer>
                                <div class="font-weight-bold">
                                    <v-skeleton-loader width="100" type="text"></v-skeleton-loader>
                                </div>
                            </v-layout>
                            <div class="text-caption font-weight-medium">
                                Surname
                            </div>
                            <div class="font-weight-bold text--h6">
                                <v-skeleton-loader type="text"></v-skeleton-loader>
                            </div>
                            <div class="text-caption font-weight-medium">
                                Forename
                            </div>
                            <div class="font-weight-bold text--h6">
                                <v-skeleton-loader type="text"></v-skeleton-loader>
                            </div>
                            <div class="text-caption font-weight-medium">
                                Birth date
                            </div>
                            <div class="font-weight-bold text--h6">
                                <v-skeleton-loader type="text"></v-skeleton-loader>
                            </div>
                        </v-layout>
                    </v-flex>
                    <v-btn color="primary" depressed>See more
                        <v-icon>navigate_next</v-icon>
                    </v-btn>
                </v-layout>
            </v-flex>
        </v-layout>
    </v-card>
</template>

