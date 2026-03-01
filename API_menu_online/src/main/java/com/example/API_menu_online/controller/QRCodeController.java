package com.example.API_menu_online.controller;

import com.example.API_menu_online.entity.Restaurant;
import com.example.API_menu_online.repository.RestaurantRepository;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Optional;

@RestController
@RequestMapping("/restaurant")
public class QRCodeController {

    private final RestaurantRepository restaurantRepository;

    @Value("${app.base.url:http://localhost:8080}")
    private String baseUrl;
    
    @Value("${app.context.path:/API_menu_online}")
    private String contextPath;

    public QRCodeController(RestaurantRepository restaurantRepository) {
        this.restaurantRepository = restaurantRepository;
    }

    @GetMapping("/{id}/qr")
    public ResponseEntity<byte[]> getRestaurantQRCode(@PathVariable("id") Long id) throws WriterException, IOException {
        Optional<Restaurant> optRestaurant = restaurantRepository.findById(id);
        if (optRestaurant.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        // Tạo URL đến trang menu (cùng backend server)
        String path = contextPath.endsWith("/") ? contextPath : contextPath + "/";
        String menuUrl = baseUrl + path + "restaurant/" + id + "/menu";

        System.out.println("QR Code URL: " + menuUrl);

        QRCodeWriter qrCodeWriter = new QRCodeWriter();
        BitMatrix bitMatrix = qrCodeWriter.encode(menuUrl, BarcodeFormat.QR_CODE, 300, 300);

        ByteArrayOutputStream pngOutputStream = new ByteArrayOutputStream();
        MatrixToImageWriter.writeToStream(bitMatrix, "PNG", pngOutputStream);

        byte[] pngData = pngOutputStream.toByteArray();

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.IMAGE_PNG);

        return ResponseEntity.ok().headers(headers).body(pngData);
    }
}