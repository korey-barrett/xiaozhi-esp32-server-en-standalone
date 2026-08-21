package xiaozhi.common.utils;

import org.bouncycastle.asn1.gm.GMNamedCurves;
import org.bouncycastle.asn1.x9.X9ECParameters;
import org.bouncycastle.crypto.engines.SM2Engine;
import org.bouncycastle.crypto.params.ECDomainParameters;
import org.bouncycastle.crypto.params.ECPrivateKeyParameters;
import org.bouncycastle.crypto.params.ECPublicKeyParameters;
import org.bouncycastle.crypto.params.ParametersWithRandom;
import org.bouncycastle.jcajce.provider.asymmetric.ec.BCECPrivateKey;
import org.bouncycastle.jcajce.provider.asymmetric.ec.BCECPublicKey;
import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.bouncycastle.math.ec.ECPoint;
import org.bouncycastle.util.encoders.Hex;

import java.math.BigInteger;
import java.security.*;
import java.security.spec.ECGenParameterSpec;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

/**
 * SM2 encryption utility class (uses hexadecimal format, consistent with the chancheng-archive-service project)
 */
public class SM2Utils {

    /**
     * Public key constant
     */
    public static final String KEY_PUBLIC_KEY = "publicKey";
    /**
     * Private key return value constant
     */
    public static final String KEY_PRIVATE_KEY = "privateKey";

    static {
        Security.addProvider(new BouncyCastleProvider());
    }

    /**
     * SM2 encryption algorithm
     *
     * @param publicKey hexadecimal public key
     * @param data      plaintext data
     * @return hexadecimal ciphertext
     */
    public static String encrypt(String publicKey, String data) {
        try {
            // Retrieve a set of SM2 curve parameters
            X9ECParameters sm2ECParameters = GMNamedCurves.getByName("sm2p256v1");
            // Construct the ECC algorithm parameters: curve equation, elliptic curve point G, and large integer N
            ECDomainParameters domainParameters = new ECDomainParameters(sm2ECParameters.getCurve(), sm2ECParameters.getG(), sm2ECParameters.getN());
            // Extract the public key point
            ECPoint pukPoint = sm2ECParameters.getCurve().decodePoint(Hex.decode(publicKey));
            // A leading 02 or 03 on the public key indicates a compressed public key, while 04 indicates an uncompressed one; for 04, the leading 04 can be removed
            ECPublicKeyParameters publicKeyParameters = new ECPublicKeyParameters(pukPoint, domainParameters);

            SM2Engine sm2Engine = new SM2Engine(SM2Engine.Mode.C1C3C2);
            // Set SM2 to encryption mode
            sm2Engine.init(true, new ParametersWithRandom(publicKeyParameters, new SecureRandom()));

            byte[] in = data.getBytes(StandardCharsets.UTF_8);
            byte[] arrayOfBytes = sm2Engine.processBlock(in, 0, in.length);
            return Hex.toHexString(arrayOfBytes);
        } catch (Exception e) {
            throw new RuntimeException("SM2 encryption failed", e);
        }
    }

    /**
     * SM2 decryption algorithm
     *
     * @param privateKey hexadecimal private key
     * @param cipherData hexadecimal ciphertext data
     * @return plaintext
     */
    public static String decrypt(String privateKey, String cipherData) {
        try {
            // When encrypting/decrypting with the BC library, ciphertext starts with 04; add a leading 04 if the passed ciphertext does not have one
            if (!cipherData.startsWith("04")) {
                cipherData = "04" + cipherData;
            }
            byte[] cipherDataByte = Hex.decode(cipherData);
            BigInteger privateKeyD = new BigInteger(privateKey, 16);
            // Retrieve a set of SM2 curve parameters
            X9ECParameters sm2ECParameters = GMNamedCurves.getByName("sm2p256v1");
            // Construct the domain parameters
            ECDomainParameters domainParameters = new ECDomainParameters(sm2ECParameters.getCurve(), sm2ECParameters.getG(), sm2ECParameters.getN());
            ECPrivateKeyParameters privateKeyParameters = new ECPrivateKeyParameters(privateKeyD, domainParameters);

            SM2Engine sm2Engine = new SM2Engine(SM2Engine.Mode.C1C3C2);
            // Set SM2 to decryption mode
            sm2Engine.init(false, privateKeyParameters);

            byte[] arrayOfBytes = sm2Engine.processBlock(cipherDataByte, 0, cipherDataByte.length);
            return new String(arrayOfBytes, StandardCharsets.UTF_8);
        } catch (Exception e) {
            throw new RuntimeException("SM2 decryption failed", e);
        }
    }

    /**
     * Generates a key pair
     */
    public static Map<String, String> createKey() {
        try {
            ECGenParameterSpec sm2Spec = new ECGenParameterSpec("sm2p256v1");
            // Retrieve an elliptic curve type key pair generator
            KeyPairGenerator kpg = KeyPairGenerator.getInstance("EC", new BouncyCastleProvider());
            // Initialize the generator with the SM2 parameters
            kpg.initialize(sm2Spec);
            // Generate the key pair
            KeyPair keyPair = kpg.generateKeyPair();
            PublicKey publicKey = keyPair.getPublic();
            BCECPublicKey p = (BCECPublicKey) publicKey;
            PrivateKey privateKey = keyPair.getPrivate();
            BCECPrivateKey s = (BCECPrivateKey) privateKey;
            
            Map<String, String> result = new HashMap<>();
            result.put(KEY_PUBLIC_KEY, Hex.toHexString(p.getQ().getEncoded(false)));
            result.put(KEY_PRIVATE_KEY, Hex.toHexString(s.getD().toByteArray()));
            return result;
        } catch (Exception e) {
            throw new RuntimeException("Failed to generate SM2 key pair", e);
        }
    }


}