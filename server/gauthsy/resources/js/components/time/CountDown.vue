<template>
    <v-layout align-center justify-center column>
        <v-card-title :style="'word-break:break-word;transform: scale('+($vuetify.breakpoint.lgAndUp?.9:1)+')'"
                      class=" pa-0 text-center text-uppercase"
                      v-if="stop||pending||delivered||returned||rejected||ready||pickedUp">
            {{
                pending ? 'Waiting for confirmation' : (preparing ? 'Preparing' : (delivering ? 'Delivering' : (delivered ? 'Delivered' : (returned ? 'Returned' : (rejected ? 'Rejected' : (ready ? 'Ready' : (pickedUp ? 'Picked up' : 'Coming soon')))))))
            }}
        </v-card-title>
        <flip-countdown class="layout wrap align-center justify-center ma-0 pa-0"
                        :style="$vuetify.breakpoint.mdAndUp?'min-width:225px;transform: scale(.6)':'min-width:225px;transform: scale(.8)'"
                        :stop="stop" :deadline="formattedDeadline" v-else></flip-countdown>
    </v-layout>
</template>

<script>
import FlipCountdown from 'vue2-flip-countdown'

export default {
    components: {FlipCountdown},
    props: {
        order: {type: Object, required: true}
    },
    computed: {
        formattedDeadline() {
            return (new Date(this.deadline)).toLocaleString()
        },
        pending() {
            return this.order.status === 'PENDING'
        },
        preparing() {
            return this.order.status === 'PREPARING'
        },
        delivering() {
            return this.order.status === 'DELIVERING'
        },
        delivered() {
            return this.order.status === 'DELIVERED'
        },
        returned() {
            return this.order.status === 'RETURNED'
        },
        rejected() {
            return this.order.status === 'REJECTED'
        },
        ready() {
            return this.order.status === 'READY'
        },
        pickedUp() {
            return this.order.status === 'PICKED_UP'
        },
        deadline() {
            return this.order.delivered_at
        },
        stop() {
            return new Date(this.deadline) < new Date()
        }
    },

}
</script>
