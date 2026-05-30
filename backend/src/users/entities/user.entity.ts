import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

export type Genre = 'homme' | 'femme' | 'autre';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Index()
  @Column({ type: 'varchar', unique: true, length: 20 })
  phone!: string;

  @Column({ type: 'varchar', nullable: true, length: 30, unique: true })
  pseudo!: string | null;

  @Column({ type: 'smallint', nullable: true })
  age!: number | null;

  @Column({ type: 'varchar', length: 10, nullable: true })
  genre!: Genre | null;

  @Column({ name: 'photo_url', type: 'text', nullable: true })
  photoUrl!: string | null;

  @Column({ name: 'trust_score', type: 'smallint', default: 0 })
  trustScore!: number;

  @Column({ name: 'is_profile_complete', type: 'boolean', default: false })
  isProfileComplete!: boolean;

  @CreateDateColumn({ name: 'created_at' })
  createdAt!: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt!: Date;
}
