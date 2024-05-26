<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/images/users/{userId}/documents/{documentId}/{filename}', function (Request $request, int $userId, int $documentId, string $filename) {
    return (new \App\GraphQL\Repositories\DocumentRepository())->getImage($request->query('token'), $userId, $documentId, $filename);
});
Route::get('/app/gauthsy.apk', function () {
    $file = public_path() . "/app/gauthsy.apk";

    $headers = array(
        'Content-Type: application/apk',
    );
    return response()->download($file, 'gauthsy.apk', $headers);
});
Route::get('/privacy_policy', function () {
    return view('privacy_policy');
});

Route::get('/{url?}/{url2?}/{url3?}/{url4?}/{url5?}/{url6?}', function () {
    return view('welcome');
});



