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
            <v-toolbar-title class="headline font-weight-bold">
                Scanning finished
            </v-toolbar-title>

        </v-app-bar>
        <v-sheet height="100"></v-sheet>
        <v-layout>
            <v-flex lg4 sm3 class="hidden-xs-only"></v-flex>
            <v-flex lg4 sm6 xs12>
                <v-card flat>
                    <v-layout align-center column justify-center>
                        <v-img contain height="200" width="200" src="/images/defaults/boarding2.png"></v-img>
                        <v-card-title class="headline text-center">Identification submitted successfully</v-card-title>
                        <v-card-subtitle class="text-center">Thank you for using our online identification service! You can now close the
                            app and will be informed about the next steps.
                        </v-card-subtitle>
                        <v-img contain height="200" width="200" src="/images/defaults/boarding1.png"></v-img>
    <div  class="px-3" style="width: 100%;">
        <v-btn block :to="{name:'home', replace: true}" depressed color="success">Finish</v-btn>
    </div>
                        <v-sheet height="20"></v-sheet>
                    </v-layout>
                </v-card>
            </v-flex>
            <v-flex lg4 sm3 class="hidden-xs-only"></v-flex>
        </v-layout>
    </v-layout>
</template>
