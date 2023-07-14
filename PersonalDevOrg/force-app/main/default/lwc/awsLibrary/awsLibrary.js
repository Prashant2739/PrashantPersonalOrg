const getAWS = () => {
	const AWS = window.AWS;
	return AWS;
};

const getAlbums = (albumBucketName, callBack, awsObjectAPIVersion) => {
	var gS3 = configureS3(albumBucketName, awsObjectAPIVersion);
	
	if (gS3 !== undefined) {
		return gS3.listObjects({ Delimiter: "/" }, callBack);
	}
};

const configureS3 = (bucketName, awsObjectAPIVersion) => {
	const AWS = window.AWS;
	return new AWS.S3({
		apiVersion: awsObjectAPIVersion?awsObjectAPIVersion:'2006-03-01', //API version for making aws callouts Ex. "2006-03-01",
		params: { Bucket: bucketName }	 //Bucket to be considered for aws operations
	});
};

const getPhotosForAlbum = (bucketName, awsObjectAPIVersion) => {
	console.log('bucketName'+bucketName);
	//console.log('albumName'+albumName);
	console.log('awsObjectAPIVersion'+awsObjectAPIVersion);
	var gS3 = configureS3(bucketName, awsObjectAPIVersion);
	
	if (gS3 !== undefined) {
		var promise = gS3.listObjectsV2({ }).promise();
		return promise
		.then((data) => {
			var albumPhotos = [];
			var photoUrl = gS3.endpoint.href;
			photoUrl = photoUrl + bucketName + "/";
			data.Contents.map((data) => {
				albumPhotos.push({
					photoUrl: photoUrl + encodeURIComponent(data.Key),
					prefix: data.Key,
					size: data.Size / 1024,
					photoKey: data.Key,
					name: data.Key.substring(data.Key.indexOf("/") + 1)
				});
			});
			return albumPhotos;
		})
		.catch((error) => {
			return error;
		});
	}
	console.log('albumPhotos'+albumPhotos);
};

const deleteAlbum = (bucketName, albumNameKey, awsObjectAPIVersion) => {
	var gS3 = configureS3(bucketName, awsObjectAPIVersion);
	
	//to delete an album all its contents needs to be deleted first. we can delete them all
	//using a single request by sending an array of s3 objects keys to be deleted.
	
	var promise = getPhotosForAlbum(bucketName, albumNameKey.substring(0, albumNameKey.length - 1));
	var Keys = [];
	
	return promise
	.then((data) => {
		data.forEach((key) => {
			Keys.push({
				Key: key.photoKey
			});
			
			deletePhotos(bucketName, Keys).then((data) => {
				return data;
			}).catch( (error) => {
				console.error(`Error occurred while deleting photo album =>${error}`);
			});
		});
	})
	.catch((error) => {
		console.error(error);
	});
};

const deletePhotos = (bucketName, photoKey, awsObjectAPIVersion) => {
	var gS3 = configureS3(bucketName, awsObjectAPIVersion);
	
	var params = {
		Bucket: bucketName,
		Delete: {
			Objects: photoKey,
			Quiet: false
		}
	};
	
	return gS3
	.deleteObjects(params)
	.promise()
	.then((data) => {
		return data;
	})
	.catch((error) => {
		console.error(`Error occurred while deleting photos =>${error}`);
		return error;
	});
};

const updateAWSConfig = (region, identityPoolId, awsCredentialObject) => {
	let AWS = window.AWS;
	AWS.config.region = region; // Region
	AWS.config.credentials = new AWS.Credentials({
		accessKeyId: awsCredentialObject.accessKeyId,
		secretAccessKey: awsCredentialObject.secretAccessKey,
		sessionToken: awsCredentialObject.sessionToken
	});
	console.log('AWS.config.credentials'+JSON.stringify(AWS.config.credentials));
};

const uploadFileToAWS = (file, recordId, awsBucketName, awsObjectAPIVersion, awsPartSize, awsQueueSize) => {
	//Initilize S3 object with AWS object version and bucket name.
	let s3 = new AWS.S3({
		apiVersion: awsObjectAPIVersion,
		params: { Bucket: awsBucketName }
	});
	
	//Initilize upload options with AWS part size and queue size parameters.
	let uploadOptions = {
		partSize  : awsPartSize?(1024*1024*parseInt(awsPartSize,10)):(1024*1024*5),
		queueSize : awsQueueSize?awsQueueSize:5,
	};

	//Create param obj with file details.
	let params = {
		Body         : file,
		Key          : recordId + '/' + file.name,
		ACL          : 'public-read',
		ContentType :  file.type,
		Tagging      : 'PhotoAlbum=' + recordId
	};
	//Upload file to AWS S3 bucket.                
	let upload = s3.upload(params, uploadOptions);
	return upload;
};

export {
	getAWS,
	getAlbums,
	getPhotosForAlbum,
	uploadFileToAWS,
	updateAWSConfig,
	configureS3,
	deletePhotos,
	deleteAlbum
};