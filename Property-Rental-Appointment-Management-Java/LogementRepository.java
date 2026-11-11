package repository;

import java.util.ArrayList;
import java.util.List;
import entity.Logement;
import entity.Logement.Type;

public class LogementRepository {
    private final List<Logement> logements;

    public LogementRepository() {
        logements = new ArrayList<>();
        logements.add(new Logement(1, "Example street 1", "El Ghazela", "Ariana",
                Type.Studio, "Equipped kitchen", 300f));
        logements.add(new Logement(2, "Example street 2", "Riadh El Andalous", "Ariana",
                Type.Appartement, "Heating, elevator, air conditioning", 700f));
        logements.add(new Logement(3, "Example street 3", "El Aouina", "Ariana",
                Type.Appartement, "S+2, heating, elevator", 500f));
    }

    public List<Logement> getAllLogements() { return logements; }

    public List<Logement> getLogementsByType(Type type) {
        List<Logement> result = new ArrayList<>();
        for (Logement logement : logements) {
            if (logement.getType().equals(type)) result.add(logement);
        }
        return result;
    }

    public void saveLogement(Logement logement) { logements.add(logement); }

    public Logement getLogementsByReference(int reference) {
        for (Logement logement : logements) {
            if (logement.getReference() == reference) return logement;
        }
        return null;
    }
}
