<template>
    <v-card tile class="blue-grey darken-4 white--text text-center" flat>
        <v-layout>
            <v-flex md3 xs0 sm1></v-flex>
            <v-flex sm10 xs12 md6>
                <v-card-text>
                    <v-layout align-center justify-space-around wrap>
                        <v-tooltip top>
                            <span class="m-headline">Ivan Kankeu</span>
                            <template v-slot:activator="{ on, attrs }">
                                <div class="elevation-5 image" v-on="on" v-bind="attrs">
                                    <a href="https://twitter.com/Ikankeu12" target="_blank" @click.stop>
                                        <v-avatar size="150">
                                            <v-img
                                                class="white--text"
                                                src="https://pbs.twimg.com/profile_images/848610718983364609/c0jTUMLU_400x400.jpg"
                                            ></v-img>
                                        </v-avatar>
                                    </a>
                                </div>
                            </template>
                        </v-tooltip>
                        <v-tooltip top>
                            <span class="m-headline">Dannick Kwengang</span>
                            <template v-slot:activator="{ on, attrs }">

                                <div class="elevation-5 image" v-on="on" v-bind="attrs">
                                    <a href="https://de.linkedin.com/in/dannick-arnold-kwengang-tankeu-b13636153/de-de" target="_blank" @click.stop>
                                        <v-avatar size="150">
                                            <v-img class="white--text"
                                                   src="https://media-exp1.licdn.com/dms/image/C5603AQHjcg89u9j68Q/profile-displayphoto-shrink_200_200/0/1594829207973?e=1622073600&v=beta&t=5SHrDmfEtrofbnM3YszsI86QBYQKUbGEby_FV_ZSarQ"></v-img>
                                        </v-avatar>
                                    </a>
                                </div>
                            </template>
                        </v-tooltip>
                    </v-layout>
                </v-card-text>
            </v-flex>
            <v-flex md3 xs0 sm1></v-flex>
        </v-layout>
    </v-card>
</template>

<script>
export default {};
</script>

<style scoped>
.image {
    background: white;
    padding: 5px;
    width: 160px;
    border-radius: 50%;
}

.m-headline {
    font-size: 20px !important;
    line-height: 28px !important;
}
</style>
