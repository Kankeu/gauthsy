<template>
    <v-card flat>
        <v-card-title class="pa-0">
            <v-icon>timelapse</v-icon>
            &nbsp;Delivery hours
        </v-card-title>
        <v-list>
            <v-layout wrap justify-space-between align-center v-for="k in getKeys(opt(value))" :key="k">
                <v-list-item-content>
                    <v-list-item-title>
                        {{ k|capitalize }}
                    </v-list-item-title>
                </v-list-item-content>
                <v-list-item-action>
                    {{ value[k].open_at }} - {{ value[k].close_at }}
                </v-list-item-action>
                <v-list-item-action>
                    <v-layout>
                        <v-btn @click="edit(k)" icon color="accent">
                            <v-icon>edit</v-icon>
                        </v-btn>
                        <v-btn :disabled="getKeys(opt(value)).length===1" @click="remove(k)" icon color="error">
                            <v-icon>delete</v-icon>
                        </v-btn>
                    </v-layout>
                </v-list-item-action>
            </v-layout>
            <v-btn block color="accent" depressed :disabled="getKeys(opt(value)).length>=7" @click="add">
                <v-icon>add</v-icon>
            </v-btn>
        </v-list>
        <v-dialog v-model="dialog" max-width="300">
            <v-card>
                <v-card-title>
                    Delivery hours
                    <v-spacer></v-spacer>
                    <v-btn @click="dialog=false" icon>
                        <v-icon>close</v-icon>
                    </v-btn>
                </v-card-title>
                <v-card-text class="pa-2">
                 <v-form ref="form2">
                     <v-overflow-btn
                         label="Day"
                         editable
                         class="mb-2"
                         :rules="$validations.make('required','filled')"
                         v-model="form.day"
                         item-text="text"
                         item-value="value"
                         :items="days.map(e=>({text:$options.filters.capitalize(e),value:e}))"
                     >
                     </v-overflow-btn>
                     <v-menu
                         ref="menu"
                         :close-on-content-click="false"
                         :return-value.sync="form.open_at"
                         transition="scale-transition"
                         max-width="290px"
                         min-width="290px"
                     >
                         <template v-slot:activator="{ on, attrs }">
                             <v-text-field
                                 readonly
                                 v-bind="attrs"
                                 v-on="on"
                                 :rules="$validations.make('required','filled')"
                                 v-model.trim="form.open_at" outlined label="Open at"
                                 placeholder="HH:mm"></v-text-field>
                         </template>
                         <v-time-picker
                             v-model="form.open_at"
                             full-width
                             format="24hr"
                             @click:minute="$refs.menu.save(form.open_at)"
                         ></v-time-picker>
                     </v-menu>
                     <v-menu
                         ref="menu2"
                         :close-on-content-click="false"
                         :return-value.sync="form.close_at"
                         transition="scale-transition"
                         max-width="290px"
                         min-width="290px"
                     >
                         <template v-slot:activator="{ on, attrs }">
                             <v-text-field
                                 readonly
                                 v-bind="attrs"
                                 v-on="on"
                                 :disabled="form.open_at==null"
                                 :rules="$validations.make('required','filled','minTime('+form.open_at+')')"
                                 v-model.trim="form.close_at" outlined label="Close at"
                                 placeholder="HH:mm"></v-text-field>
                         </template>
                         <v-time-picker
                             v-model="form.close_at"
                             full-width
                             format="24hr"
                             @click:minute="$refs.menu2.save(form.close_at)"
                         ></v-time-picker>
                     </v-menu>
                 </v-form>
                </v-card-text>
                <v-card-actions class="pt-0">
                    <v-btn @click="save" block color="accent" depressed>
                        Save
                    </v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
    </v-card>
</template>

<script>

export default {
    props: {
        value: {validator: prop =>  prop instanceof Object || prop === null, required: true},
    },
    data: () => ({
        dialog: false,
        form: {
            day: null,
            open_at: null,
            close_at: null
        }
    }),
    methods: {
        getKeys(v){
            return Object.keys(v)
        },
        edit(k) {
            this.form.day = k;
            this.form.open_at=this.value[k].open_at
            this.form.close_at=this.value[k].close_at
            this.dialog = true
        },
        remove(k) {
            let tmp =  {...this.value}
            delete tmp[k]
            this.$emit('input', tmp)
        },
        add() {
            this.dialog = true
        },
        save() {
            if(!this.$refs.form2.validate()) return;
            let tmp = this.value == null ? {} : {...this.value}
            tmp[this.form.day] = {open_at: this.form.open_at, close_at: this.form.close_at}
            this.$emit('input', tmp)
            this.dialog = false
        }
    },
    watch: {
        dialog(v) {
            if (!v) {
                this.form = {
                    day: null,
                    open_at: null,
                    close_at: null
                }
            }
        }
    }
}
</script>
