<?php

/**
 * PartuturanCalculator - Hitung hubungan kekerabatan Batak (partuturan)
 * antara dua orang dalam pohon silsilah.
 * 
 * Sistem kekerabatan Batak (Dalihan Na Tolu):
 * - Hula-hula (pihak pemberi perempuan / pihak istri)
 * - Dongan Tubu (seketurunan / semarga)
 * - Boru (pihak penerima perempuan / pihak menantu)
 * 
 * Sebutan kekerabatan Batak:
 * - Amang = Ayah
 * - Inang = Ibu
 * - Ompung = Kakek/Nenek
 * - Anak = Anak
 * - Ianggi = Saudara laki-laki (adik)
 * - Anggi = Saudara perempuan
 * - Lae = Saudara laki-laki istri / suami saudara perempuan
 * - Pariban = Saudara perempuan istri / istri saudara laki-laki (bisa dinikahi)
 * - Tulang = Paman (saudara laki-laki ibu)
 * - Nantulang = Istri paman
 * - Inang ni lae = Ibu saudara perempuan
 * - Amanguda = Paman (adik ayah)
 * - Amangtua = Paman (kakak ayah)
 * - Eda = Istri saudara laki-laki
 * - Bere = Anak saudara perempuan
 * - Hahamaranggi = Sepupu
 */

class PartuturanCalculator
{
    private $pdo;

    public function __construct(PDO $pdo)
    {
        $this->pdo = $pdo;
    }

    /**
     * Dapatkan jalur dari node ke root (semua leluhur)
     * @return array [nodeId, parentId, grandParentId, ...]
     */
    public function getAncestorPath($nodeId): array
    {
        $path = [];
        $current = $nodeId;
        $visited = [];

        while ($current && !isset($visited[$current])) {
            $visited[$current] = true;
            $path[] = $current;

            $stmt = $this->pdo->prepare("SELECT orang_tuan_id FROM silsilah_mitolologis WHERE id = ?");
            $stmt->execute([$current]);
            $current = $stmt->fetchColumn();
        }

        return $path;
    }

    /**
     * Cari Lowest Common Ancestor (LCA) dari dua node
     * @return array ['lca' => nodeId, 'depth1' => jarak dari node1 ke LCA, 'depth2' => jarak dari node2 ke LCA]
     */
    public function findLCA($nodeId1, $nodeId2): array
    {
        $path1 = $this->getAncestorPath($nodeId1);
        $path2 = $this->getAncestorPath($nodeId2);

        $set1 = array_flip($path1);

        foreach ($path2 as $depth2 => $node) {
            if (isset($set1[$node])) {
                $depth1 = $set1[$node];
                return [
                    'lca' => $node,
                    'depth1' => $depth1,
                    'depth2' => $depth2,
                    'path1' => $path1,
                    'path2' => $path2,
                ];
            }
        }

        return ['lca' => null, 'depth1' => -1, 'depth2' => -1, 'path1' => $path1, 'path2' => $path2];
    }

    /**
     * Hitung sebutan kekerabatan Batak antara dua node
     * @return array dengan sebutan_batak, sebutan_indonesia, tingkat, jalur
     */
    public function calculate($nodeId1, $nodeId2): array
    {
        if ($nodeId1 == $nodeId2) {
            return [
                'sebutan_batak' => 'Diri sendiri',
                'sebutan_indonesia' => 'Diri sendiri',
                'tingkat' => 0,
                'jalur' => 'Orang yang sama',
                'lca' => $nodeId1,
            ];
        }

        $lca = $this->findLCA($nodeId1, $nodeId2);

        if ($lca['lca'] === null) {
            // Tidak ada common ancestor - mungkin dari root berbeda
            return [
                'sebutan_batak' => 'Tidak ada hubungan silsilah',
                'sebutan_indonesia' => 'Tidak terhubung dalam pohon silsilah',
                'tingkat' => -1,
                'jalur' => 'Kedua orang berada di root/leluhur yang berbeda',
                'lca' => null,
            ];
        }

        $d1 = $lca['depth1']; // jarak node1 ke LCA
        $d2 = $lca['depth2']; // jarak node2 ke LCA

        // Ambil info gender
        $stmt = $this->pdo->prepare("SELECT nama, jenis_kelamin, marga_turunan FROM silsilah_mitolologis WHERE id IN (?, ?)");
        $stmt->execute([$nodeId1, $nodeId2]);
        $nodes = $stmt->fetchAll(PDO::FETCH_ASSOC);
        $n1 = null;
        $n2 = null;
        foreach ($nodes as $n) {
            if ($n['id'] == $nodeId1) $n1 = $n;
            if ($n['id'] == $nodeId2) $n2 = $n;
        }

        $jk1 = $n1['jenis_kelamin'] ?? 'L';
        $jk2 = $n2['jenis_kelamin'] ?? 'L';
        $marga1 = $n1['marga_turunan'] ?? '';
        $marga2 = $n2['marga_turunan'] ?? '';
        $sameMarga = !empty($marga1) && !empty($marga2) && stripos($marga1, $marga2) !== false || stripos($marga2, $marga1) !== false;

        $result = $this->determinePartuturan($d1, $d2, $jk1, $jk2, $sameMarga, $n1['nama'], $n2['nama']);
        $result['lca'] = $lca['lca'];

        // Build jalur deskripsi
        $result['jalur'] = $this->buildJalur($lca, $nodeId1, $nodeId2);

        return $result;
    }

    /**
     * Tentukan sebutan partuturan berdasarkan kedalaman dan gender
     */
    private function determinePartuturan($d1, $d2, $jk1, $jk2, $sameMarga, $nama1, $nama2): array
    {
        // Node1 = orang yang bertanya, Node2 = orang yang ditanya

        // === Node2 adalah leluhur langsung node1 ===
        if ($d2 == 0 && $d1 > 0) {
            return $this->leluhurLangsung($d1, $jk2);
        }

        // === Node1 adalah leluhur langsung node2 ===
        if ($d1 == 0 && $d2 > 0) {
            return $this->keturunanLangsung($d2, $jk2);
        }

        // === Saudara (satu orang tua) ===
        if ($d1 == 1 && $d2 == 1) {
            return $this->saudaraSeayah($jk1, $jk2);
        }

        // === Sepupu (kakek/nenek sama) ===
        if ($d1 == 2 && $d2 == 2) {
            return [
                'sebutan_batak' => $jk2 == 'L' ? 'Hahamaranggi' : 'Ianggi (sepupu perempuan)',
                'sebutan_indonesia' => 'Sepupu',
                'tingkat' => 2,
            ];
        }

        // === Node2 adalah paman/tante (saudara ayah) ===
        if ($d1 >= 2 && $d2 == 1) {
            // Node2 adalah saudara dari leluhur node1
            if ($jk2 == 'L') {
                if ($d1 == 2) {
                    return [
                        'sebutan_batak' => 'Tulang / Amangtua / Amanguda',
                        'sebutan_indonesia' => 'Paman (saudara ayah)',
                        'tingkat' => 2,
                    ];
                }
                return [
                    'sebutan_batak' => 'Ompung Doli (leluhur)',
                    'sebutan_indonesia' => 'Paman jauh / leluhur',
                    'tingkat' => $d1,
                ];
            } else {
                return [
                    'sebutan_batak' => 'Inang Tua / Nantulang',
                    'sebutan_indonesia' => 'Tante / Bibi',
                    'tingkat' => 2,
                ];
            }
        }

        // === Node1 adalah paman/tante dari node2 ===
        if ($d2 >= 2 && $d1 == 1) {
            if ($jk1 == 'L') {
                return [
                    'sebutan_batak' => 'Amang (bagi ' . $nama2 . ')',
                    'sebutan_indonesia' => 'Paman dari ' . $nama2,
                    'tingkat' => $d2,
                ];
            } else {
                return [
                    'sebutan_batak' => 'Inang (bagi ' . $nama2 . ')',
                    'sebutan_indonesia' => 'Tante dari ' . $nama2,
                    'tingkat' => $d2,
                ];
            }
        }

        // === Sepupu derajat lebih jauh ===
        if ($d1 == $d2 && $d1 > 2) {
            $tingkat = $d1 - 1;
            return [
                'sebutan_batak' => $sameMarga ? 'Dongan Tubu (semarga)' : 'Hahamaranggi (sepupu jauh)',
                'sebutan_indonesia' => "Sepupu tingkat {$tingkat}",
                'tingkat' => $d1,
            ];
        }

        // === Node2 lebih dekat ke leluhur tapi bukan leluhur langsung ===
        if ($d2 < $d1) {
            $diff = $d1 - $d2;
            if ($d2 == 1) {
                return [
                    'sebutan_batak' => $jk2 == 'L' ? 'Tulang (paman)' : 'Inang Tua (bibi)',
                    'sebutan_indonesia' => 'Paman/Bibi',
                    'tingkat' => $d1,
                ];
            }
            return [
                'sebutan_batak' => 'Ompung (leluhur)',
                'sebutan_indonesia' => 'Leluhur jauh',
                'tingkat' => $d1,
            ];
        }

        // === Node1 lebih dekat ke leluhur ===
        if ($d1 < $d2) {
            if ($d1 == 1) {
                return [
                    'sebutan_batak' => $jk2 == 'L' ? 'Anak' : 'Anak Boru',
                    'sebutan_indonesia' => 'Keponakan / Keturunan',
                    'tingkat' => $d2,
                ];
            }
            return [
                'sebutan_batak' => $jk2 == 'L' ? 'Bere (cucu)' : 'Bere Boru',
                'sebutan_indonesia' => 'Keturunan jauh',
                'tingkat' => $d2,
            ];
        }

        // === Default: semarga atau tidak terhubung ===
        if ($sameMarga) {
            return [
                'sebutan_batak' => 'Dongan Tubu (semarga)',
                'sebutan_indonesia' => 'Semarga (seketurunan)',
                'tingkat' => max($d1, $d2),
            ];
        }

        return [
            'sebutan_batak' => 'Partutuan jauh',
            'sebutan_indonesia' => 'Kerabat jauh',
            'tingkat' => max($d1, $d2),
        ];
    }

    /**
     * Leluhur langsung (orang tua, kakek, buyut)
     */
    private function leluhurLangsung($depth, $jk): array
    {
        switch ($depth) {
            case 1:
                return [
                    'sebutan_batak' => $jk == 'L' ? 'Amang' : 'Inang',
                    'sebutan_indonesia' => $jk == 'L' ? 'Ayah' : 'Ibu',
                    'tingkat' => 1,
                ];
            case 2:
                return [
                    'sebutan_batak' => $jk == 'L' ? 'Ompung Doli' : 'Ompung Boru',
                    'sebutan_indonesia' => $jk == 'L' ? 'Kakek' : 'Nenek',
                    'tingkat' => 2,
                ];
            case 3:
                return [
                    'sebutan_batak' => 'Ompung ni Ompung',
                    'sebutan_indonesia' => 'Buyut',
                    'tingkat' => 3,
                ];
            default:
                return [
                    'sebutan_batak' => 'Leluhur (Sundut ke-' . ($depth + 4),
                    'sebutan_indonesia' => "Leluhur generasi ke-{$depth}",
                    'tingkat' => $depth,
                ];
        }
    }

    /**
     * Keturunan langsung (anak, cucu, cicit)
     */
    private function keturunanLangsung($depth, $jk): array
    {
        switch ($depth) {
            case 1:
                return [
                    'sebutan_batak' => $jk == 'L' ? 'Anak' : 'Boru',
                    'sebutan_indonesia' => $jk == 'L' ? 'Anak laki-laki' : 'Anak perempuan',
                    'tingkat' => 1,
                ];
            case 2:
                return [
                    'sebutan_batak' => $jk == 'L' ? 'Pahompu' : 'Boru ni Anak',
                    'sebutan_indonesia' => $jk == 'L' ? 'Cucu laki-laki' : 'Cucu perempuan',
                    'tingkat' => 2,
                ];
            case 3:
                return [
                    'sebutan_batak' => 'Nini',
                    'sebutan_indonesia' => 'Cicit',
                    'tingkat' => 3,
                ];
            default:
                return [
                    'sebutan_batak' => 'Keturunan (Sundut ke-' . ($depth + 4) . ')',
                    'sebutan_indonesia' => "Keturunan generasi ke-{$depth}",
                    'tingkat' => $depth,
                ];
        }
    }

    /**
     * Saudara seayah
     */
    private function saudaraSeayah($jk1, $jk2): array
    {
        if ($jk2 == 'L') {
            return [
                'sebutan_batak' => 'Ianggi / Haha (saudara laki-laki)',
                'sebutan_indonesia' => 'Saudara laki-laki',
                'tingkat' => 1,
            ];
        } else {
            return [
                'sebutan_batak' => 'Anggi / Eda (saudara perempuan)',
                'sebutan_indonesia' => 'Saudara perempuan',
                'tingkat' => 1,
            ];
        }
    }

    /**
     * Build deskripsi jalur
     */
    private function buildJalur($lca, $nodeId1, $nodeId2): string
    {
        if (!$lca['lca']) return 'Tidak ada jalur';

        $stmt = $this->pdo->prepare("SELECT nama FROM silsilah_mitolologis WHERE id = ?");
        $stmt->execute([$lca['lca']]);
        $lcaNama = $stmt->fetchColumn() ?: '?';

        $path1Names = [];
        foreach ($lca['path1'] as $i => $nid) {
            if ($i > $lca['depth1']) break;
            $stmt = $this->pdo->prepare("SELECT nama FROM silsilah_mitolologis WHERE id = ?");
            $stmt->execute([$nid]);
            $path1Names[] = $stmt->fetchColumn() ?: '?';
        }

        $path2Names = [];
        foreach ($lca['path2'] as $i => $nid) {
            if ($i > $lca['depth2']) break;
            $stmt = $this->pdo->prepare("SELECT nama FROM silsilah_mitolologis WHERE id = ?");
            $stmt->execute([$nid]);
            $path2Names[] = $stmt->fetchColumn() ?: '?';
        }

        $jalur = implode(' → ', array_reverse($path1Names));
        $jalur .= ' ← [LCA: ' . $lcaNama . '] → ';
        $jalur .= implode(' → ', array_reverse($path2Names));

        return $jalur;
    }

    /**
     * Cache hasil ke partuturan_log
     */
    public function cacheResult($nodeId1, $nodeId2, $result): void
    {
        $stmt = $this->pdo->prepare("INSERT INTO partuturan_log (node_id_1, node_id_2, sebutan_batak, sebutan_indonesia, tingkat_kekerabatan, jalur) VALUES (?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE sebutan_batak = VALUES(sebutan_batak), sebutan_indonesia = VALUES(sebutan_indonesia), tingkat_kekerabatan = VALUES(tingkat_kekerabatan), jalur = VALUES(jalur), dihitung_pada = CURRENT_TIMESTAMP");
        $stmt->execute([
            $nodeId1, $nodeId2,
            $result['sebutan_batak'] ?? null,
            $result['sebutan_indonesia'] ?? null,
            $result['tingkat'] ?? null,
            $result['jalur'] ?? null,
        ]);
    }
}
