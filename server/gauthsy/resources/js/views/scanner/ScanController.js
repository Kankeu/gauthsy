const IJS = require('image-js').Image;
const parse = require('mrz').parse;

export default {
    data() {
        return {
            form: {
                images: []
            },
            workerLoading: false,
            firstDialog: false,
            secondDialog: false,
            thirdDialog: false,
            step: 1,
            scan: null,
            progress: 0,
            scanning: false,
            loading: true,
            video: null,
            canvas: null,
            worker: null,
            displaySize: null,

            counter: 0,
            samples: [],
        };
    },
    computed: {
        front() {
            return this.form.images.find(e => e.type === 'FRONT')
        },
        face() {
            return this.form.images.find(e => e.type === 'FACE')
        },
        frontFace() {
            return this.form.images.find(e => e.type === 'FRONT_FACE')
        },
    },
    methods: {
        rescan() {
            this.canvas.style.display = 'none'
            if (this.step === 1) {
                this.progress = 0
                this.firstDialog = false
            }
            if (this.step === 2) {
                this.progress = 0
                this.counter = 0
                this.samples = []
                this.secondDialog = false
            }
            if (this.step === 3) {
                this.progress = 0
                this.thirdDialog = false
            }

            this.startScan()
        },
        next() {
            this.canvas.style.display = 'none'
            this.progress = 0
            if (this.step === 1) {
                this.$snackbar.show({
                    text: 'Flip the document',
                    color: 'success',
                    timeout: 6000
                })
                this.firstDialog = false
            }
            if (this.step === 2) {
                this.$snackbar.show({
                    text: 'Take a selfie',
                    color: 'success',
                    timeout: 6000
                })
                this.secondDialog = false
            }
            if (this.step === 3) {
                this.$snackbar.show({
                    text: 'Scanning finished',
                    color: 'success',
                    timeout: 6000
                })
                this.thirdDialog = false
                this.$emit('scan', this.form)
                return;
            }
            this.step++
            this.startScan()
        },
        endScan() {
            this.canvas.style.display = 'none'
            window.clearInterval(this.scan)
            this.scanning = false
        },
        startScan() {
            this.scanning = true

            this.scan = setInterval(async () => {
                if (!this.scanning) return;
                if (this.step === 1) {
                    await this.firstScan()
                } else if (this.step === 2) {
                    await this.secondScan()
                } else if (this.step === 3) {
                    await this.thirdScan()
                }


                //faceapi.draw.drawFaceExpressions(canvas, resizedDetections)
            }, 300)
        },
        async firstScan() {
            /*   console.log(parse([
                   "ard<<y095wpxw88<<<<<<<<<<<<<<<",
                   "9906127m2106109cmr<<<<<<<<<<<0",
                   "kankeu<fembu<<ivan<nelson<<<<<"
               ].map(e => e.toUpperCase())))*/
            const video = this.video

            const canvas = this.canvas
            const displaySize = this.displaySize
            const docImg = this.$refs.webcam.capture()
            const detection = await faceapi.detectSingleFace(video, new faceapi.TinyFaceDetectorOptions()).withFaceLandmarks()
            if (detection) {
                this.canvas.style.display = 'block'
                if (detection.detection.score < .5) {
                    this.progress = .5

                    this.$snackbar.show({

                        text: 'Zoom on the document',
                        timeout: 3000
                    })
                } else {
                    this.progress = .5

                    this.endScan()

                    let box = {
                        x: detection.detection.box.x,
                        y: detection.detection.box.y,
                        width: detection.detection.box.width,
                        height: detection.detection.box.height
                    }
                    box.x -= 15
                    box.y -= 70
                    box.width += 30
                    box.height += 80
                    try {
                        this.img = (await IJS.load(docImg)).crop(box).toDataURL()
                    } catch (e) {
                        this.$snackbar.show({
                            text: "Center the document in the camera's field of view",
                            timeout: 6000
                        })
                        this.rescan()
                        return;
                    }
                    let index = this.form.images.findIndex(e => e.type === 'FRONT')
                    if (index > -1)
                        this.form.images.splice(index, 1)
                    this.form.images.push({file: docImg, type: 'FRONT'})
                    index = this.form.images.findIndex(e => e.type === 'FRONT_FACE')
                    if (index > -1)
                        this.form.images.splice(index, 1)
                    this.form.images.push({file: this.img, type: 'FRONT_FACE'})
                    this.progress = 1
                    this.firstDialog = true

                }
                const resizedDetections = faceapi.resizeResults(detection, displaySize)
                canvas.getContext('2d').clearRect(0, 0, canvas.width, canvas.height)
                faceapi.draw.drawDetections(canvas, resizedDetections)
                faceapi.draw.drawFaceLandmarks(canvas, resizedDetections)
            } else this.canvas.style.display = 'none'
        },
        async secondScan() {
            if (this.workerLoading) return
            this.workerLoading = true
            this.worker.postMessage({
                cmd: 'process',
                image: this.$refs.webcam.capture()
            });
        },
        async thirdScan() {
            const video = this.video

            const canvas = this.canvas
            const displaySize = this.displaySize

            const detection = await faceapi.detectSingleFace(video, new faceapi.TinyFaceDetectorOptions()).withFaceLandmarks()
            if (detection) {
                this.canvas.style.display = 'block'
                if (detection.detection.score < .5) {
                    this.progress = .5

                    this.$snackbar.show({
                        text: "Center your face in the camera's field of view",
                        timeout: 6000
                    })
                } else {
                    this.progress = .5

                    this.endScan()
                    this.progress = .5
                    let index = this.form.images.findIndex(e => e.type === 'FACE')
                    if (index > -1)
                        this.form.images.splice(index, 1)
                    this.form.images.push({file: this.$refs.webcam.capture(), type: 'FACE'})
                    this.progress = 1
                    this.thirdDialog = true
                }
                const resizedDetections = faceapi.resizeResults(detection, displaySize)
                canvas.getContext('2d').clearRect(0, 0, canvas.width, canvas.height)
                faceapi.draw.drawDetections(canvas, resizedDetections)
                faceapi.draw.drawFaceLandmarks(canvas, resizedDetections)
            } else this.canvas.style.display = 'none'
        },
        initWorker() {
            var blob = new Blob(
                [mrz_worker.toString().replace(/^function .+\{?|\}$/g, '')],
                {type: 'text/javascript'}
            );
            var objectURL = URL.createObjectURL(blob);
            var worker = new Worker(objectURL);

            worker.addEventListener('error', function (e) {
                console.log(e);
            }, false);

            worker.addEventListener('message', (e) => {
                var data = e.data;

                switch (data.type) {
                    case 'progress':
                        console.log(data)
                        break;

                    case 'error':
                        console.error(data);
                        this.workerLoading = false
                        break;

                    case 'result':
                        console.log(data)
                        if (!data.result.error) {
                            data.result.ocrized.forEach((l, i) => {
                                l = l.toLowerCase().trim()
                                if (!this.samples[i]) this.samples[i] = {}
                                this.samples[i][l] = (this.samples[i][l] || 0) + 1
                            })
                            this.counter++
                            this.progress = this.counter / 5


                            if (this.progress === 1) {
                                let index = this.form.images.findIndex(e => e.type === 'BACK')
                                if (index > -1)
                                    this.form.images.splice(index, 1)
                                this.form.images.push({file: this.$refs.webcam.capture(), type: 'BACK'})


                                let mrz = this.samples.map(sample => {
                                    let currentKey;
                                    for (let key in sample)
                                        if (sample[currentKey] == null || sample[key] >= sample[currentKey]) currentKey = key;
                                    return currentKey.toUpperCase()
                                });
                                var result = parse(mrz);
                                let check = false
                                if (result.fields.issuingState)
                                    check = this.form.type === result.fields.documentCode && this.form.issued_by === ({
                                        'D': 'DE',
                                        'CMR': 'CM',
                                        'RWA': 'RW'
                                    })[result.fields.issuingState]
                                let expiry_date = this.$options.filters.fromIntToDate(result.fields.expirationDate)

                                let validated = check && result.fields.documentNumber != null && result.fields.lastName != null
                                    && result.fields.firstName != null && (this.form.type === "AR" ? result.fields.nationality != null : true)
                                    && result.fields.sex != null && result.fields.birthDate != null && expiry_date != null

                                if (!validated) {
                                    this.progress = 0
                                    this.counter = 0
                                    this.samples = []
                                    this.$snackbar.show({
                                        text: check ? 'Invalid document! Please retry again' : 'Scanning failed! Please retry again',
                                        color: 'error',
                                        timeout: 6000
                                    })
                                }
                                if (Date.parse(expiry_date) <= Date.now()) {
                                    this.progress = 0
                                    this.counter = 0
                                    this.samples = []
                                    this.$snackbar.show({
                                        text: 'Document has expired!',
                                        color: 'error',
                                        timeout: 6000
                                    })
                                } else {
                                    this.endScan()
                                    this.form.number = result.fields.documentNumber
                                    this.form.payload = {
                                        document_number: result.fields.documentNumber,
                                        surname: result.fields.lastName,
                                        forename: result.fields.firstName,
                                        country_code: result.fields.issuingState,
                                        document_type: result.fields.documentCode,
                                        sex: result.fields.sex === 'female' ? "F" : "M",
                                        birth_date: this.$options.filters.fromIntToDate(result.fields.birthDate),
                                        expiry_date: expiry_date,
                                    }
                                    if (result.fields.nationality)
                                        this.form.payload.nationality_country_code = result.fields.nationality
                                    if(result.fields.optional1)
                                        this.form.payload.personal_number = result.fields.optional1
                                    if(result.fields.optional2)
                                        this.form.payload.personal_number2 = result.fields.optional2

                                    this.secondDialog = true
                                }
                                console.log(mrz, result);

                            }
                        }
                        console.log(this.samples)
                        this.workerLoading = false
                        break;

                    default:
                        this.workerLoading = false
                        console.log(data);
                        break;

                }
            }, false);

            var pathname = document.location.pathname.split('/');
            pathname.pop();
            pathname = pathname.join('/');

            worker.postMessage({
                cmd: 'config',
                config: {
                    fsRootUrl: document.location.origin + pathname
                }
            });

            return worker;
        },
    },
}
