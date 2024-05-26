<template>
    <div
        style="background-color: black;width: 100%;height: 100%;z-index: 9;position: fixed;top:0;bottom: 0;left: 0;right: 0">
        <v-layout fill-height justify-space-around align-center v-if="loading">
            <v-progress-circular size="200" indeterminate></v-progress-circular>
        </v-layout>
        <v-layout v-else align-center column justify-end
        >
            <v-layout
                id="video-container"
                align-center justify-center style="position: fixed;top:50px">
                <!--
                                         :resolution=" {
                     width: { ideal: width*3 },
                     height: { ideal: 310*3 }
                 } "
                                 -->
                <vue-web-cam
                    ref="webcam"
                    :class="$vuetify.breakpoint.xsOnly?'mt-6':''"
                    style="z-index: 7;object-fit: cover;border-radius: 2px"
                    :device-id="deviceId"
                    :width="width*(step===3?.75:1)"
                    :height="(step===3?310:height)"
                    :resolution=" {
                     width: { ideal: 1800 },
                     height: { ideal: 1200 }
                 }"
                    @started="onStarted"
                    @stopped="onStopped"
                    @error="onError"
                    @cameras="onCameras"
                    @camera-change="onCameraChange"
                ></vue-web-cam>
                <v-sheet v-if="scanning" :class="$vuetify.breakpoint.xsOnly?'mt-6':''" :width="width*(step===3?.75:1)" :height="(step===3?310:height)" color="transparent"
                         style="position: absolute;z-index: 8">
                    <v-sheet class="diode">
                        <v-sheet class="laser" :style="$vuetify.breakpoint.xsOnly&&step!==3?'animation: scanningXSOnly 2s infinite;':''" color="red" height="5" width="100%"></v-sheet>
                    </v-sheet>
                </v-sheet>
            </v-layout>
            <v-btn style="top:15px" @click="$router.back()" absolute top left fab>
                <v-icon>navigate_before</v-icon>
            </v-btn>

            <v-card class="py-3" flat :height="height" style="position: absolute;bottom: 50px" :width="width">
                <v-layout fill-height column justify-space-around>
                    <v-layout justify-space-around>
                        <v-chip :color="i<step?'success':null" v-for="i in 3" :key="i"
                                :large="!$vuetify.breakpoint.xsOnly">
                            <v-avatar
                                :style="!$vuetify.breakpoint.xsOnly?'width: 50px !important;height: 50px !important;':'width: 25px !important;height: 25px !important;'"
                                :color="i===step?'primary':'white'"
                                :class="i===step?'white--text':'black--text'" left>
                               <template v-if="scanning&&step===i">
                                   <v-progress-circular
                                       :rotate="360"
                                       :size="$vuetify.breakpoint.xsOnly?25:50"
                                       :width="$vuetify.breakpoint.xsOnly?10:15"
                                       :value="progress*100"
                                       color="accent"
                                   >
                                   </v-progress-circular>
                               </template>
                                <template v-else>
                                    <v-icon v-if="i<step">check</v-icon>
                                    <span v-else>{{ i }}</span>
                                </template>
                            </v-avatar>
                            {{ scanning&&step===i?($options.filters.truncNum(progress * 100)+"% scanning") :(i === 1 ? 'Front side' : (i === 2 ? 'Back side' : 'Face')) }}
                        </v-chip>
                    </v-layout>
                    <v-layout v-if="initialized" align-center justify-space-around>
                        <v-btn @click="flip" color="primary" large fab>
                            <v-icon>flip_camera_android</v-icon>
                        </v-btn>
                        <v-btn v-if="scanning" @click="endScan" color="error" x-large fab>
                            <v-icon>stop</v-icon>
                        </v-btn>
                        <v-btn v-else @click="startScan" color="primary" x-large fab>
                            <v-icon>camera</v-icon>
                        </v-btn>
                        <v-btn @click="triggerFlash" color="primary" large fab>
                            <v-icon>{{ flash ? 'flash_off' : 'flash_on' }}</v-icon>
                        </v-btn>
                    </v-layout>
                </v-layout>
            </v-card>
            <v-dialog :value="true" persistent overlay-opacity=".5" v-if="firstDialog" max-width="400">
                <v-card>
                    <v-card-title>
                        Are the images correct ?
                        <v-spacer></v-spacer>
                        <v-card-text>
                            <v-layout column align-center justify-space-between>
                                <v-card-subtitle>Is the avatar correctly cropped ?</v-card-subtitle>
                                <v-avatar class="mt-1" tile size="150">
                                    <v-img :src="frontFace.file" contain height="150" width="150"></v-img>
                                </v-avatar>
                                <v-card-subtitle class="mt-3">Is the document correctly captured ?</v-card-subtitle>
                                <v-img class="mt-1" width="100%" :height="210" :src="front.file"></v-img>
                            </v-layout>
                        </v-card-text>
                        <v-card-actions class="layout">
                            <v-spacer></v-spacer>
                            <v-btn text color="primary" @click="rescan">Rescan</v-btn>
                            <v-btn text color="accent" @click="next">Confirm</v-btn>
                        </v-card-actions>
                    </v-card-title>
                </v-card>
            </v-dialog>
            <v-dialog :value="true" persistent overlay-opacity=".5" v-if="thirdDialog" max-width="400">
                <v-card>
                    <v-card-title>
                        Is the selfie correct ?
                        <v-spacer></v-spacer>
                        <v-card-text>
                                <v-img class="mt-1" width="100%" :height="310" :src="face.file"></v-img>
                        </v-card-text>
                        <v-card-actions class="layout">
                            <v-spacer></v-spacer>
                            <v-btn text color="primary" @click="rescan">Rescan</v-btn>
                            <v-btn text color="accent" @click="next">Confirm</v-btn>
                        </v-card-actions>
                    </v-card-title>
                </v-card>
            </v-dialog>
            <SecondScanDialog @rescan="rescan" @confirm="next" :value="secondDialog" :document="form" v-if="secondDialog"/>
        </v-layout>
    </div>
</template>

<script>
import {WebCam} from "vue-web-cam";
import fetchInject from "fetch-inject";
import ScanController from './ScanController'
import SecondScanDialog from "./SecondScanDialog";


export default {
    name: "App",
    mixins: [ScanController],
    components: {
        SecondScanDialog,
        "vue-web-cam": WebCam
    },
    data() {
        return {
            flash: false,
            camera: null,
            deviceId: null,
            initialized: false,
            devices: [],
        };
    },
    computed: {
        width() {
            return (this.innerWidth < 600 ? (this.innerWidth * .9) : 500)
        },
        height() {
            return this.$vuetify.breakpoint.xsOnly?210:310
        },
        device() {
            return this.devices.find(n => n.deviceId === this.deviceId);
        }
    },
    watch: {
        camera(id) {
            this.deviceId = id;
        },
        devices() {
            // Once we have a list select the first one
            const [first, ...tail] = this.devices;
            if (first) {
                this.camera = first.deviceId;
                this.deviceId = first.deviceId;
            }
        }
    },
    methods: {
        onCapture() {
            this.img = this.$refs.webcam.capture();
        },
        onStarted(stream) {
            console.log("On Started Event", stream);
            this.stream = stream
            if (!this.initialized) {
                const video = this.$el.querySelector('video')
                console.log(video)
                video.addEventListener('play', () => {
                    this.video = this.$el.querySelector('video')

                    this.canvas = faceapi.createCanvasFromMedia(video)
                    document.querySelector('#video-container').append(this.canvas)
                    this.displaySize = {width: video.width, height: video.height}
                    faceapi.matchDimensions(this.canvas, this.displaySize)
                })
                this.initialized=true
            }
        },
        onStopped(stream) {
            console.log("On Stopped Event", stream);
        },
        onStop() {
            this.$refs.webcam.stop();
        },
        triggerFlash() {
            this.flash = !this.flash
            this.stream.getVideoTracks()[0].applyConstraints({
                advanced: [{torch: this.flash}]
            })
        },
        onStart() {
            this.$refs.webcam.start();
        },
        onError(error) {
            console.log("On Error Event", error);
        },
        onCameras(cameras) {
            this.devices = cameras;
            console.log("On Cameras Event", cameras);
        },
        flip() {
            this.onCameraChange(this.devices.map(e => e.deviceId).indexOf(this.camera) === 0 && this.devices.length > 1 ? this.devices[1].deviceId : this.devices[0].deviceId)
        },
        onCameraChange(deviceId) {
            this.deviceId = deviceId;
            this.camera = deviceId;
            console.log("On Camera Change Event", deviceId);
        },
    },
    mounted() {
        fetchInject(['/js/mrz-worker.bundle-min-wrapped.js', '/js/face-api.min.js']).then(async _ => {
            await Promise.all([
                await faceapi.nets.tinyFaceDetector.loadFromUri('/js/models'),
                await faceapi.nets.faceLandmark68Net.loadFromUri('/js/models'),
                await faceapi.nets.faceRecognitionNet.loadFromUri('/js/models'),
                await faceapi.nets.faceExpressionNet.loadFromUri('/js/models')
            ])
            try {
                this.worker = this.initWorker();
            } catch (err) {
                console.log(err)
            }
            this.loading = false
        })
        this.form.type = this.$route.query.type
        this.form.issued_by = this.$route.query.issued_by
    }
};
</script>

<style>
canvas {
    position: absolute;
    z-index: 8;
}

.laser {
    background-color: tomato;
    height: 1px;
    position: absolute;
    z-index: 2;
    box-shadow: 0 0 4px red;
    animation: scanning 2s infinite;
}

.diode {
    animation: beam .01s infinite;
}


@keyframes beam {
    50% {
        opacity: 0;
    }
}

@keyframes scanningXSOnly {
    50% {
        transform: translateY(205px);
    }
}
@keyframes scanning {
    50% {
        transform: translateY(305px);
    }
}
</style>
