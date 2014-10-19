package com.coubr.business.services;

import com.coubr.business.exceptions.QRCodeGenerationException;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageConfig;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import org.springframework.stereotype.Service;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;

/**
 * Created by sebastian on 14.10.14.
 */
@Service("codeServoce")
public class CodeService {

    enum CodeType {
        STORE("coubrStore:"), COUPON("coubrCoupon:");

        private String preamble;

        private CodeType(String preamble) {
            this.preamble = preamble;
        }

        private String getPreamble() {
            return preamble;
        }
    }

    private QRCodeWriter qrCodeWriter = new QRCodeWriter();

    public byte[] generateQRCode(String code, CodeType type, int dimension) throws QRCodeGenerationException {

        if (dimension < 0) {
            throw new QRCodeGenerationException();
        }

        try {
            String contents = type.getPreamble() + code;
            BarcodeFormat format;
            BitMatrix matrix = qrCodeWriter.encode(contents, BarcodeFormat.QR_CODE, dimension, dimension);

            int onColor = 0xFFF2784B;
            int offColor = 0xFFF2F1EF;
            MatrixToImageConfig config = new MatrixToImageConfig(onColor, offColor);
            BufferedImage image = MatrixToImageWriter.toBufferedImage(matrix, config);

            ByteArrayOutputStream bao = new ByteArrayOutputStream();
            ImageIO.write(image, "png", bao);

            return bao.toByteArray();
        } catch (IOException ex) {
            throw new QRCodeGenerationException();
        } catch (WriterException ex) {
            throw new QRCodeGenerationException();
        }


    }

}
