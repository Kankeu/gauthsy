<template>
    <v-dialog v-model="dialog"  max-width="400">
      <template  v-slot:activator="{on,attrs}">
          <v-btn v-if="preventAndStop" @click.prevent.stop="" :style="styleBtn" v-bind="attrs" :small="small" :fab="fab" :class="classNames" :height="height" :depressed="depressed" v-on="on" :color="color" :loading="loading" :tile="tile" :block="block">
              <slot></slot>
          </v-btn>
          <v-btn v-else :style="styleBtn" v-bind="attrs" :small="small" :fab="fab" :class="classNames" :height="height" :depressed="depressed" v-on="on" :color="color" :loading="loading" :tile="tile" :block="block">
              <slot></slot>
          </v-btn>
      </template>
        <v-card>
            <v-card-title>{{confirmTitle}}</v-card-title>
            <v-card-text v-html="confirmHintText"></v-card-text>
            <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn text @click="cancel">Cancel</v-btn>
                <v-btn text color="accent" @click="confirm">Confirm</v-btn>
            </v-card-actions>
        </v-card>
    </v-dialog>
</template>

<script>
    export default {
        props: {
            confirmHintText: {
                type: String,
                require: true
            },
            confirmTitle: {
                type: String,
                require: true
            },
            depressed: {
                type: Boolean,
                default: false
            },
            loading: {
                type: Boolean,
                default: false
            },
            preventAndStop: {
                type: Boolean,
                default: false
            },
            styleBtn:{
                type: String
            },
            block: {
                type: Boolean,
                default: false
            },
            classNames: {
                type: String,
            },
            small: {
                type: Boolean,
                default: false
            },
            tile: {
                type: Boolean,
                default: false
            },
            fab: {
                type: Boolean,
                default: false
            },
            color: {
                type: String
            },
            height:{
                type: Number
            }
        },
        data: () => ({
            dialog: false
        }),
        methods: {
            open() {
                this.dialog = true
            },
            confirm() {
                this.$emit('click')
                this.dialog=false
            },
            cancel() {
                this.dialog = false
            }
        }
    }
</script>
