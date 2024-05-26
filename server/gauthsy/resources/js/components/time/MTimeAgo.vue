<template>
    <time-ago :datetime="datetime" locale="en"></time-ago>
</template>

<script>
    export default {
        props:{
            datetime:{
                type: String
            }
        }
    }
</script>
