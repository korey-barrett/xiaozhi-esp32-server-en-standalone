import { getServiceUrl } from '../api';
import RequestService from '../httpRequest';

export default {
    // Paginated query of OTA firmware info
    getOtaList(params, callback) {
        RequestService.sendRequest()
            .url(`${getServiceUrl()}/otaMag`)
            .method('GET')
            .data(params)
            .success((res) => {
                RequestService.clearRequestTime();
                callback(res);
            })
            .networkFail((err) => {
                console.error('Failed to get the OTA firmware list:', err);
                RequestService.reAjaxFun(() => {
                    this.getOtaList(params, callback);
                });
            }).send();
    },
    // Get a single OTA firmware info
    getOtaInfo(id, callback) {
        RequestService.sendRequest()
            .url(`${getServiceUrl()}/otaMag/${id}`)
            .method('GET')
            .success((res) => {
                RequestService.clearRequestTime();
                callback(res);
            })
            .networkFail((err) => {
                console.error('Failed to get the OTA firmware info:', err);
                RequestService.reAjaxFun(() => {
                    this.getOtaInfo(id, callback);
                });
            }).send();
    },
    // Save OTA firmware info
    saveOta(entity, callback) {
        RequestService.sendRequest()
            .url(`${getServiceUrl()}/otaMag`)
            .method('POST')
            .data(entity)
            .success((res) => {
                RequestService.clearRequestTime();
                callback(res);
            })
            .networkFail((err) => {
                console.error('Failed to save the OTA firmware info:', err);
                RequestService.reAjaxFun(() => {
                    this.saveOta(entity, callback);
                });
            }).send();
    },
    // Update OTA firmware info
    updateOta(id, entity, callback) {
        RequestService.sendRequest()
            .url(`${getServiceUrl()}/otaMag/${id}`)
            .method('PUT')
            .data(entity)
            .success((res) => {
                RequestService.clearRequestTime();
                callback(res);
            })
            .networkFail((err) => {
                console.error('Failed to update the OTA firmware info:', err);
                RequestService.reAjaxFun(() => {
                    this.updateOta(id, entity, callback);
                });
            }).send();
    },
    // Delete OTA firmware
    deleteOta(id, callback) {
        RequestService.sendRequest()
            .url(`${getServiceUrl()}/otaMag/${id}`)
            .method('DELETE')
            .success((res) => {
                RequestService.clearRequestTime();
                callback(res);
            })
            .networkFail((err) => {
                console.error('Failed to delete the OTA firmware:', err);
                RequestService.reAjaxFun(() => {
                    this.deleteOta(id, callback);
                });
            }).send();
    },
    // Upload the firmware file
    uploadFirmware(file, callback) {
        const formData = new FormData();
        formData.append('file', file);
        RequestService.sendRequest()
            .url(`${getServiceUrl()}/otaMag/upload`)
            .method('POST')
            .data(formData)
            .success((res) => {
                RequestService.clearRequestTime();
                callback(res);
            })
            .networkFail((err) => {
                console.error('Failed to upload the firmware file:', err);
                RequestService.reAjaxFun(() => {
                    this.uploadFirmware(file, callback);
                });
            }).send();
    },
    // Get the firmware download link
    getDownloadUrl(id, callback) {
        RequestService.sendRequest()
            .url(`${getServiceUrl()}/otaMag/getDownloadUrl/${id}`)
            .method('GET')
            .success((res) => {
                RequestService.clearRequestTime();
                callback(res);
            })
            .networkFail((err) => {
                console.error('Failed to get the download link:', err);
                RequestService.reAjaxFun(() => {
                    this.getDownloadUrl(id, callback);
                });
            }).send();
    }
}