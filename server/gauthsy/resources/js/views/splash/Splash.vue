<template>
    <v-layout column fill-height align-center justify-center>
        <v-progress-circular
            :size="150"
            color="primary"
            indeterminate
        >
            <v-avatar>
                <v-img :src="$config.images.logo" height="50" width="50"></v-img>
            </v-avatar>
        </v-progress-circular>
    </v-layout>
</template>

<script>

export default {
    created() {
        this.$router.push({name: 'starting',query:{retrieve: this.$route.query.retrieve,redirect: this.$route.query.redirect}});
    }
}
</script>
