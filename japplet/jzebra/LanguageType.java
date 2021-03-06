package net.is_bg.ltf.japplet.jzebra;

/**
 * Enum for print languages, such as ZPL, EPL, etc.
 * @author tfino
 */
public enum LanguageType {

    ZPLII, ZPL, EPL2, EPL, CPCL, ESCP, UNKNOWN;

    LanguageType() {
    }

    public static LanguageType getType(String s) {
        for (LanguageType lt : LanguageType.values()) {
            if (s.equalsIgnoreCase(lt.name())) {
                return lt;
            }
        }
        if (s.equalsIgnoreCase("ZEBRA")) {
            return ZPLII;
        } else if (s.equalsIgnoreCase("ZPL2")) {
            return ZPLII;
        } else if (s.equalsIgnoreCase("EPLII")) {
            return EPL2;
        } else if (s.equalsIgnoreCase("EPSON")) {
            return ESCP;
        }
        return UNKNOWN;
    }
}