package repository;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import entity.Logement;
import entity.RendezVous;

public class RendezVousRepository {
    private final List<RendezVous> listeRendezVous;
    private final LogementRepository logementMetier = new LogementRepository();

    public RendezVousRepository() {
        listeRendezVous = new ArrayList<>();
        listeRendezVous.add(new RendezVous(1, "31-10-2015", "15:30",
                logementMetier.getLogementsByReference(1), "00000000"));
    }

    public List<RendezVous> getListeRendezVous() { return listeRendezVous; }

    public boolean addRendezVous(RendezVous rendezVous) {
        Logement logement = logementMetier.getLogementsByReference(
                rendezVous.getLogement().getReference());
        if (logement == null) return false;
        rendezVous.setLogement(logement);
        return listeRendezVous.add(rendezVous);
    }

    public List<RendezVous> getListeRendezVousByLogementRef(int reference) {
        List<RendezVous> result = new ArrayList<>();
        for (RendezVous rdv : listeRendezVous) {
            if (rdv.getLogement().getReference() == reference) result.add(rdv);
        }
        return result;
    }

    public boolean updateRendezVous(RendezVous rendezVous) {
        int index = listeRendezVous.indexOf(rendezVous);
        if (index < 0) return false;
        Logement logement = logementMetier.getLogementsByReference(
                rendezVous.getLogement().getReference());
        if (logement == null) return false;
        rendezVous.setLogement(logement);
        listeRendezVous.set(index, rendezVous);
        return true;
    }

    public Logement getLogementByRDV(int idRDV) {
        for (RendezVous rdv : listeRendezVous) {
            if (rdv.getId() == idRDV) return rdv.getLogement();
        }
        return null;
    }

    public boolean deleteRendezVous(int id) {
        Iterator<RendezVous> iterator = listeRendezVous.iterator();
        while (iterator.hasNext()) {
            if (iterator.next().getId() == id) {
                iterator.remove();
                return true;
            }
        }
        return false;
    }
}
