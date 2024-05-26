class EventManager {

    constructor() {
        this.listeners = {}
    }

    has(key) {
        return this.listeners[key] instanceof Array
    }

    attach(channel, callback) {
        if (!this.has(channel)) this.listeners[channel] = []
        return this.listeners[channel].push(callback) - 1
    }

    detach(channel, callbackId) {
        if (this.has(channel)) {
            this.listeners[channel].splice(callbackId, 1)
            this.listeners[channel].length === 0 && delete this.listeners[channel]
        }
    }

    trigger(channel, data = null) {
        this.has(channel) && this.listeners[channel].forEach(callback => callback(data))
    }

}

export default new EventManager()
