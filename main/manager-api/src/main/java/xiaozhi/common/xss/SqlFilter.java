package xiaozhi.common.xss;

import org.apache.commons.lang3.StringUtils;

import xiaozhi.common.exception.ErrorCode;
import xiaozhi.common.exception.RenException;

/**
 * SQL filter
 * Copyright (c) Renren Open Source All rights reserved.
 * Website: https://www.renren.io
 */
public class SqlFilter {

    /**
     * SQL injection filter
     *
     * @param str the string to be validated
     */
    public static String sqlInject(String str) {
        if (StringUtils.isBlank(str)) {
            return null;
        }
        // Remove the '|"|;|\ characters
        str = str.replace("'", "");
        str = str.replace("\"", "");
        str = str.replace(";", "");
        str = str.replace("\\", "");

        // Convert to lowercase
        str = str.toLowerCase();

        // Illegal keywords
        String[] keywords = { "master", "truncate", "insert", "select", "delete", "update", "declare", "alter",
                "drop" };

        // Check whether it contains illegal keywords
        for (String keyword : keywords) {
            if (str.contains(keyword)) {
                throw new RenException(ErrorCode.INVALID_SYMBOL);
            }
        }

        return str;
    }
}
