<template>
    <v-bottom-sheet v-model="sheet">
        <template v-slot:activator="{ on, attrs }">
            <v-tooltip v-bind="attrs"
                       v-on="on" top>
                <template v-slot:activator="{ on, attrs }">
                    <v-btn :class="btnClass" @click="sheet=!sheet" fab small v-bind="attrs"
                           v-on="on" depressed color="secondary" outlined>
                        <v-icon color="accent">share</v-icon>
                    </v-btn>
                </template>
                <span>Share the restaurant</span>
            </v-tooltip>
        </template>

        <v-list>
            <v-subheader>Share with</v-subheader>
            <v-list-item
                @click="twitter"
            >
                <v-list-item-avatar>
                    <v-avatar size="32px" tile>
                        <img
                            src="http://icons.iconarchive.com/icons/uiconstock/socialmedia/256/Twitter-icon.png"
                            alt="twitter"
                        >
                    </v-avatar>
                </v-list-item-avatar>
                <v-list-item-title>Twitter</v-list-item-title>
            </v-list-item>
            <v-list-item
                @click="facebook"
            >
                <v-list-item-avatar>
                    <v-avatar size="32px" tile>
                        <img
                            src="https://image.flaticon.com/icons/svg/187/187189.svg"
                            alt="facebook"
                        >
                    </v-avatar>
                </v-list-item-avatar>
                <v-list-item-title>Facebook</v-list-item-title>
            </v-list-item>
        </v-list>
    </v-bottom-sheet>
</template>

<script>
export default {
    props: {
        restaurant: {type: Object, required: true},
        btnClass: {type: String, default: ""}
    },
    data: () => ({
        sheet: false,
    }),
    computed: {
        text() {
            return this.$config.appName + `: ${this.restaurant.name}`
        },
        url() {
            return window.location.href
        }
    },
    methods: {
        popupCenter(url, title, width, height) {
            let popupWidth = width || 640;
            let popupHeight = height || 320;
            let windowLeft = window.screenLeft || window.screenX;
            let windowTop = window.screenTop || window.screenY;
            let windowWidth = window.innerWidth || document.documentElement.clientWidth;
            let windowHeight = window.innerHeight || document.documentElement.clientHeight;
            let popupLeft = windowLeft + windowWidth / 2 - popupWidth / 2;
            let popupTop = windowTop + windowHeight / 2 - popupHeight / 2;
            let popup = window.open(url, title, 'scrollbars=yes, width=' + popupWidth + ', height=' + popupHeight + ', top=' + popupTop + ', left=' + popupLeft);
            popup.focus();
            return true;
        },
        twitter() {
            let shareUrl = "https://twitter.com/intent/tweet?text=" + this.text +
                "&url=" + encodeURIComponent(this.url)
            this.popupCenter(shareUrl, "Share on Twitter")
            this.close()
        },
        facebook() {
            let shareUrl = "https://www.facebook.com/sharer/sharer.php?u=" + encodeURIComponent(this.url)
            this.popupCenter(shareUrl, "Share on facebook");
            this.close()
        },
        close() {
            this.sheet = false
        }

    },
}
</script>
