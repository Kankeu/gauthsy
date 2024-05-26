<template>
    <v-card :flat="flat" class="text-center pa-5 ma-12" height="260">
        <v-layout column align-center justify-space-between>
            <v-icon size="100">sentiment_very_dissatisfied</v-icon>
            <v-card-title class="headline text-center">
                {{ title }}
            </v-card-title>
            <v-card-subtitle v-if="subtitle">
                {{ subtitle }}
            </v-card-subtitle>
            <v-btn v-if="refetch" block depressed @click="refetch" color="accent">Try again</v-btn>
        </v-layout>
    </v-card>
</template>

<script>

export default {
    props: {
        title: {type: String, required: true},
        subtitle: {type: String},
        flat: {type: Boolean, default: false},
        refetch: {type: Function, required: true}
    }
}
</script>
