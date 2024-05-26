<template>
    <v-layout column>
        <v-menu
            ref="menuDate"
            :close-on-content-click="false"
            :return-value.sync="form.dateTime_date"
            transition="scale-transition"
            max-width="290px"
            min-width="290px"
        >
            <template v-slot:activator="{ on, attrs }">
                <v-text-field
                    readonly
                    v-bind="attrs"
                    v-on="on"
                    clearable
                    @click:clear="clear"
                    :rules="required?$validations.make('required','filled'):[]"
                    v-model.trim="form.dateTime_date" outlined label="Expires at date"
                    placeholder="Y-m-d"></v-text-field>
            </template>
            <v-date-picker
                v-model="form.dateTime_date"
                full-width
                :min="new Date((new Date()).getTime() + 1000*60).toISOString().substr(0, 10)"
                :max="new Date((new Date()).getTime() + 1000*60*60*24*365).toISOString().substr(0, 10)"
                @change="$refs.menuDate.save(form.dateTime_date)"
            ></v-date-picker>
        </v-menu>
        <v-menu
            ref="menuTime"
            :close-on-content-click="false"
            :return-value.sync="form.dateTime_time"
            transition="scale-transition"
            max-width="290px"
            min-width="290px"
        >
            <template v-slot:activator="{ on, attrs }">
                <v-text-field
                    readonly
                    v-bind="attrs"
                    v-on="on"
                    :rules="form.dateTime_date!= null&&form.dateTime_date.trim().length>0?$validations.make('required','filled'):[]"
                    v-model.trim="form.dateTime_time" outlined label="Expires at time"
                    placeholder="HH:mm"></v-text-field>
            </template>
            <v-time-picker
                v-model="form.dateTime_time"
                full-width
                format="24hr"
                @click:minute="$refs.menuTime.save(form.dateTime_time)"
            ></v-time-picker>
        </v-menu>
    </v-layout>
</template>

<script>

export default {
    props: {
        value: {type: String},
        required: {type: Boolean, default: false},
    },
    data: () => ({
        form: {
            dateTime_date: null,
            dateTime_time: null
        }
    }),
    computed:{
        dateTime(){
            return (new Date(this.form.dateTime_date + " " + this.form.dateTime_time + ":00")).toJSON().replace("T", " ").replace("Z", "").split(".")[0];
        }
    },
    methods: {
        clear() {
            this.form.dateTime_date = null
            this.form.dateTime_time = null
        },
        save() {
            this.$nextTick(_=>{
                console.log(this.form.dateTime_date + " " + this.form.dateTime_time+":00")
                if (this.form.dateTime_date != null && this.form.dateTime_time != null)
                {
                    if(this.dateTime!==this.value)
                        this.$emit('input',this.dateTime)
                }
                else this.$emit('input', null)
            })
        },
        update() {
            if (this.value == null || this.value.trim().length === 0) {
                this.form.dateTime_date = null
                this.form.dateTime_time = null
                return;
            }
            if(this.dateTime===this.value) return;
            this.form.dateTime_date = this.value.split(" ")[0]
            this.form.dateTime_time = this.value.split(" ")[1]
        }
    },
    mounted() {
        this.update();
    },
    watch: {
        value(v) {
            this.update()
        },
        'form.dateTime_date'(v) {
            this.save()
        },
        'form.dateTime_time'(v) {
            this.save()
        }
    }
}
</script>
