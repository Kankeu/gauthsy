<template>
    <v-list-item two-line>
        <v-list-item-avatar width="50" height="50">
            <v-skeleton-loader type="image" width="50" height="50"></v-skeleton-loader>
        </v-list-item-avatar>
        <v-list-item-content>
            <v-list-item-title>
                <v-skeleton-loader type="text" width="150"></v-skeleton-loader>
            </v-list-item-title>
            <v-list-item-subtitle>
                <v-layout justify-start align-center>
                    <v-skeleton-loader type="text" width="150"></v-skeleton-loader>
                </v-layout>
            </v-list-item-subtitle>
        </v-list-item-content>
        <v-list-item-action>
            <v-skeleton-loader type="button"></v-skeleton-loader>
        </v-list-item-action>
    </v-list-item>
</template>
