<template>
<div style="width: 100%">
    <user-tile-skeleton v-if="loading"></user-tile-skeleton>
    <v-list-item :disabled="disabled" @click="dialog=!dialog" two-line v-else>
        <v-list-item-avatar width="50" height="50">
            <v-icon size="60">account_circle</v-icon>
        </v-list-item-avatar>
        <v-list-item-content>
            <v-list-item-title class="text-left text-wrap pl-1 title">
                {{ deliverer?'Deliverer':(orderer?'Orderer':$options.filters.fullName(user)) }}
            </v-list-item-title>
            <v-list-item-subtitle>
                <v-layout justify-start align-center>
                    <v-rating readonly color="primary" dense background-color="secondary"
                              half-increments half-icon="star_half"
                              :value="user.rating"></v-rating>
                    <span class="secondary--text text--lighten-2" v-if="user.evaluations_count!=null">({{ user.evaluations_count }})</span>
                </v-layout>
            </v-list-item-subtitle>
        </v-list-item-content>
        <v-list-item-action>
            <v-icon>navigate_next</v-icon>
        </v-list-item-action>
    </v-list-item>
    <v-dialog max-width="650"
                 content-class="m-ev-bg" v-model="dialog">
            <EvaluationsBody :user="user" v-if="dialog"></EvaluationsBody>
    </v-dialog>
</div>
</template>

<script>

import UserTileSkeleton from "./UserTileSkeleton";
import EvaluationsBody from "./EvaluationsBody";
export default {
    components: {EvaluationsBody, UserTileSkeleton},
    props:{
        user:{type: Object},
        loading:{type: Boolean, default: false},
        orderer:{type: Boolean, default: false},
        disabled:{type: Boolean, default: false},
        deliverer:{type: Boolean, default: false},
    },
    data:()=>({
        dialog:false
    })
}
</script>

<style>
.m-ev-bg {
    background: white;
}
</style>
